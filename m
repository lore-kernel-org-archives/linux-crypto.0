From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 1/5] crypto: ensure algif_hash does not pass a
 zero-sized state
Date: Sat, 17 Oct 2015 08:56:21 +0100
Message-ID: <20151017075621.GK32532@n2100.arm.linux.org.uk>
References: <20151009194309.GA7401@n2100.arm.linux.org.uk>
 <E1ZkdZl-0005IT-IU@rmk-PC.arm.linux.org.uk>
 <20151013143312.GA7903@gondor.apana.org.au>
 <20151015093930.GA32532@n2100.arm.linux.org.uk>
 <20151015094147.GA2157@gondor.apana.org.au>
 <20151015125944.GB32532@n2100.arm.linux.org.uk>
 <20151015131338.GA3901@gondor.apana.org.au>
 <20151016162454.64d1102514dfc9c84a9d8be1@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Horia Geant? <horia.geanta@freescale.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Victoria Milhoan <vicki.milhoan@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:42452 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbbJQH4e (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Oct 2015 03:56:34 -0400
Content-Disposition: inline
In-Reply-To: <20151016162454.64d1102514dfc9c84a9d8be1@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 16, 2015 at 04:24:54PM -0700, Victoria Milhoan wrote:
> On Thu, 15 Oct 2015 21:13:38 +0800
> Herbert Xu <herbert@gondor.apana.org.au> wrote:
> 
> > On Thu, Oct 15, 2015 at 01:59:44PM +0100, Russell King - ARM Linux wrote:
> > >
> > > I think the CAAM driver is pretty unfixable from a trivial point of
> > > view.  This driver exports a huge amount of state - it contains both a
> > > struct caam_hash_ctx and a struct caam_hash_state, which totals up to
> > > 1600 bytes.  This fails the:
> > 
> > Right just dumping the state out as is not going to work.  This
> > is not supposed to be how export works anyway.  But it doesn't
> > look too bad as most of that 1600 is consumed by the hardware
> > program descriptor which can easily be regenerated upon import.
> > 
> > The only things that need to be exported AFAICS are key and buf_X.
> 
> I just pushed out a patch for export/import functions in the CAAM driver. The
> patch has been through testing with OpenSSL and the AF_ALG plugin on the MX6.

Be careful with that.  There's two ways to test:

1. Checking hash output.

Preparation - copy openssl.cnf and add this to openssl.cnf:

openssl_conf            = openssl_def

[openssl_def]
engines                 = engine_section

[engine_section]
af_alg                  = af_alg_engine

[af_alg_engine]
CIPHERS=aes-128-cbc aes-192-cbc aes-256-cbc des-cbc des-ede3-cbc

DIGESTS=md5 sha1 sha256 sha512

# Putting this last means we register the above as the default algorithms
default_algorithms      = ALL

Then:

#!/bin/sh

for type in md5 sha1 sha256 sha512; do
   echo -n "Checking $type hash:"
   for file in /bin/*; do
      echo -n " $file"
      if ! OPENSSL_CONF=./openssl.cnf openssl dgst -$type < $file | sed "s,(stdin)= ,,;s,\$,\t$file," | ${type}sum -c > /dev/null; then
         echo " ... failed"
         echo -n "Openssl says: " >&2
         OPENSSL_CONF=./openssl.cnf openssl dgst -$type < $file | sed "s,(stdin)= ,,;s,\$,\t$file," >&2
         echo -n "${type}sum says: " >&2
         ${type}sum $file >&2
         exit 1
      fi
   done
   echo " ... ok"
done
echo "All hashes passed"

The above will verify that the hashes are producing the correct answers
for a range of files.  This does _not_ test the export/import paths.

2. Backup the existing openssl.cnf and replace it with the above modified
   version.  Then try to ssh into the platform.  This will verify the
   export/import side of things.  If ssh fails to connect to the target,
   you know that the crypto drivers for SHA1 are broken, probably due to
   export/import.

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
