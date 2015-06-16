From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH RFC v5 3/4] crypto: rsa: add a new rsa generic implementation
Date: Tue, 16 Jun 2015 04:19:52 +0200
Message-ID: <15593683.jmSB8WjLMD@tachyon.chronox.de>
References: <20150615201831.15697.57738.stgit@tstruk-mobl1> <3921303.7tkMvJ6vYE@tachyon.chronox.de> <557F809B.3060001@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	keescook@chromium.org, jwboyer@redhat.com, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47751 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbbFPCVj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 22:21:39 -0400
In-Reply-To: <557F809B.3060001@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 15. Juni 2015, 18:49:15 schrieb Tadeusz Struk:

Hi Tadeusz,

> On 06/15/2015 04:23 PM, Stephan Mueller wrote:
> >> +	/* In FIPS mode only allow key size minimum 2K */
> >> 
> >> > +	if (fips_enabled && (mpi_get_size(key->n) < 256)) {
> > 
> > Considering my previous email, shouldn't that check rather be
> > 
> > if (fips_enabled &&
> > 
> >     ((mpi_get_size(key->n) != 256) || (mpi_get_size(key->n) != 384))
> 
> I'm not familiar with the FIPS requirements. I checked the NIST
> recommendations witch states that RSA: |n| >= 2048 is acceptable. If FIPS
> allows 2K and 3K only then we need to change it.

The reason for exclusive 2k/3k is the CAVS testing: there is only the ability 
to test 2/3k. Longer key sizes are even not allowed as per SP800-131A in favor 
of EC.


-- 
Ciao
Stephan
