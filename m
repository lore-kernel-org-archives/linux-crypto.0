From: LABBE Corentin <montjoie.mailing@gmail.com>
Subject: Re: [PATCH 1/8] crypto: hash: add zero length message hash for shax
 and md5
Date: Thu, 15 Oct 2015 11:42:04 +0200
Message-ID: <20151015094204.GA6305@Red>
References: <1444668826-6531-1-git-send-email-clabbe.montjoie@gmail.com>
 <1444668826-6531-2-git-send-email-clabbe.montjoie@gmail.com>
 <20151014100802.GA15884@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>, davem@davemloft.net,
	thomas.lendacky@amd.com, geert+renesas@glider.be,
	ulf.hansson@linaro.org, wsa@the-dreams.de, keescook@chromium.org,
	maxime.ripard@free-electrons.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36529 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbbJOJmK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Oct 2015 05:42:10 -0400
Content-Disposition: inline
In-Reply-To: <20151014100802.GA15884@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 14, 2015 at 06:08:02PM +0800, Herbert Xu wrote:
> On Mon, Oct 12, 2015 at 06:53:39PM +0200, LABBE Corentin wrote:
> > Some crypto drivers cannot process empty data message and return a
> > precalculated hash for md5/sha1/sha224/sha256.
> > 
> > This patch add thoses precalculated hash in include/crypto.
> > 
> > Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> > ---
> >  include/crypto/md5.h |  5 +++++
> >  include/crypto/sha.h | 20 ++++++++++++++++++++
> >  2 files changed, 25 insertions(+)
> > 
> > diff --git a/include/crypto/md5.h b/include/crypto/md5.h
> > index 146af82..6496ee0 100644
> > --- a/include/crypto/md5.h
> > +++ b/include/crypto/md5.h
> > @@ -13,6 +13,11 @@
> >  #define MD5_H2	0x98badcfeUL
> >  #define MD5_H3	0x10325476UL
> >  
> > +static const u8 md5_zero_message_hash[MD5_DIGEST_SIZE] = {
> > +	0xd4, 0x1d, 0x8c, 0xd9, 0x8f, 0x00, 0xb2, 0x04,
> > +	0xe9, 0x80, 0x09, 0x98, 0xec, 0xf8, 0x42, 0x7e,
> > +};
> > +
> 
> This potentially creates this structure in every file that includes
> md5.h.  How about putting it into md5_generic and exporting it?
> 

md5_generic does not exists, do you mean md5.c ?
I have made some try with EXPORT_SYMBOL() but without success.
Do you have any example of how to do that ?

Regards
