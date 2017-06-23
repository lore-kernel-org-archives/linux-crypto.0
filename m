From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [bug] sha1-avx2 and read beyond
Date: Fri, 23 Jun 2017 16:43:30 +0800
Message-ID: <20170623084330.GA30353@gondor.apana.org.au>
References: <1950313665.4516034.1493507041652.JavaMail.zimbra@redhat.com>
 <502554512.20705544.1495630017500.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, ilya.albrekht@intel.com,
        maxim.locktyukhin@intel.com, ronen.zohar@intel.com,
        mouli@linux.intel.com, minipli@googlemail.com, hpa@linux.intel.com,
        marex@denx.de
To: Jan Stancek <jstancek@redhat.com>,
        Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:36012 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751217AbdFWInz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2017 04:43:55 -0400
Content-Disposition: inline
In-Reply-To: <502554512.20705544.1495630017500.JavaMail.zimbra@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 24, 2017 at 08:46:57AM -0400, Jan Stancek wrote:
> 
> 
> ----- Original Message -----
> > Hi,
> > 
> > I'm seeing rare crashes during NFS cthon with krb5 auth. After
> > some digging I arrived at potential problem with sha1-avx2.
> 
> Adding more sha1_avx2 experts to CC.
> 
> > 
> > Problem appears to be that sha1_transform_avx2() reads beyond
> > number of blocks you pass, if it is an odd number. It appears
> > to try read one block more. This creates a problem if it falls
> > beyond a page and there's nothing there.
> 
> As noted in my reply, worst case appears to be read ahead
> of up to 3 SHA1 blocks beyond end of data:
>   http://marc.info/?l=linux-crypto-vger&m=149373371023377
> 
>  +----------+---------+---------+---------+
>  | 2*SHA1_BLOCK_SIZE  | 2*SHA1_BLOCK_SIZE |
>  +----------+---------+---------+---------+
>             ^ page boundary
>     ^ data end
> 
> It is still reproducible with 4.12-rc2.

Can someone from Intel please look into this? Otherwise we'll have
to disable sha-avx2.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
