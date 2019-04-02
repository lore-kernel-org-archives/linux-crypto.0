Return-Path: <SRS0=5Ot1=SE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BEC3C4360F
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Apr 2019 16:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76D29204EC
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Apr 2019 16:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730089AbfDBQQC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Apr 2019 12:16:02 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:45384 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730479AbfDBQQC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Apr 2019 12:16:02 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 9498372CC58;
        Tue,  2 Apr 2019 19:15:58 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 7F8AF4A4A14;
        Tue,  2 Apr 2019 19:15:58 +0300 (MSK)
Date:   Tue, 2 Apr 2019 19:15:57 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [RFC/RFT PATCH 09/18] crypto: streebog - fix unaligned memory
 accesses
Message-ID: <20190402161557.lg37muib4qy4az22@altlinux.org>
Mail-Followup-To: Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org
References: <20190331200428.26597-1-ebiggers@kernel.org>
 <20190331200428.26597-10-ebiggers@kernel.org>
 <20190331214717.4erxk2racxphfbha@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20190331214717.4erxk2racxphfbha@altlinux.org>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric,

On Mon, Apr 01, 2019 at 12:47:19AM +0300, Vitaly Chikunov wrote:
> On Sun, Mar 31, 2019 at 01:04:19PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Don't cast the data buffer directly to streebog_uint512, as this
> > violates alignment rules.
> > 
> > Fixes: fe18957e8e87 ("crypto: streebog - add Streebog hash function")
> > Cc: Vitaly Chikunov <vt@altlinux.org>
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  crypto/streebog_generic.c | 25 +++++++++++++------------
> >  include/crypto/streebog.h |  5 ++++-
> >  2 files changed, 17 insertions(+), 13 deletions(-)
> > 
> > diff --git a/crypto/streebog_generic.c b/crypto/streebog_generic.c
> > index 5a2eafed9c29f..b82fc3d79aa15 100644
> > --- a/crypto/streebog_generic.c
> > +++ b/crypto/streebog_generic.c
> > @@ -996,7 +996,7 @@ static void streebog_add512(const struct streebog_uint512 *x,
> >  
> >  static void streebog_g(struct streebog_uint512 *h,
> >  		       const struct streebog_uint512 *N,
> > -		       const u8 *m)
> > +		       const struct streebog_uint512 *m)
> >  {
> >  	struct streebog_uint512 Ki, data;
> >  	unsigned int i;
> > @@ -1005,7 +1005,7 @@ static void streebog_g(struct streebog_uint512 *h,
> >  
> >  	/* Starting E() */
> >  	Ki = data;
> > -	streebog_xlps(&Ki, (const struct streebog_uint512 *)&m[0], &data);
> > +	streebog_xlps(&Ki, m, &data);
> >  
> >  	for (i = 0; i < 11; i++)
> >  		streebog_round(i, &Ki, &data);
> > @@ -1015,16 +1015,19 @@ static void streebog_g(struct streebog_uint512 *h,
> >  	/* E() done */
> >  
> >  	streebog_xor(&data, h, &data);
> > -	streebog_xor(&data, (const struct streebog_uint512 *)&m[0], h);
> > +	streebog_xor(&data, m, h);
> >  }
> >  
> >  static void streebog_stage2(struct streebog_state *ctx, const u8 *data)
> >  {
> > -	streebog_g(&ctx->h, &ctx->N, data);
> > +	struct streebog_uint512 m;
> > +
> > +	memcpy(&m, data, sizeof(m));
> > +
> > +	streebog_g(&ctx->h, &ctx->N, &m);
> >  
> >  	streebog_add512(&ctx->N, &buffer512, &ctx->N);
> > -	streebog_add512(&ctx->Sigma, (const struct streebog_uint512 *)data,
> > -			&ctx->Sigma);
> > +	streebog_add512(&ctx->Sigma, &m, &ctx->Sigma);
> >  }
> 
> As I understand, this is the actual fix.

Probably, even better would be to use CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
to optimize out memcpy() for such architectures.

Thanks,

> Reviewed-by: Vitaly Chikunov <vt@altlinux.org>
> 
> Thanks much!
> 
> >  
> >  static void streebog_stage3(struct streebog_state *ctx)
> > @@ -1034,13 +1037,11 @@ static void streebog_stage3(struct streebog_state *ctx)
> >  	buf.qword[0] = cpu_to_le64(ctx->fillsize << 3);
> >  	streebog_pad(ctx);
> >  
> > -	streebog_g(&ctx->h, &ctx->N, (const u8 *)&ctx->buffer);
> > +	streebog_g(&ctx->h, &ctx->N, &ctx->m);
> >  	streebog_add512(&ctx->N, &buf, &ctx->N);
> > -	streebog_add512(&ctx->Sigma,
> > -			(const struct streebog_uint512 *)&ctx->buffer[0],
> > -			&ctx->Sigma);
> > -	streebog_g(&ctx->h, &buffer0, (const u8 *)&ctx->N);
> > -	streebog_g(&ctx->h, &buffer0, (const u8 *)&ctx->Sigma);
> > +	streebog_add512(&ctx->Sigma, &ctx->m, &ctx->Sigma);
> > +	streebog_g(&ctx->h, &buffer0, &ctx->N);
> > +	streebog_g(&ctx->h, &buffer0, &ctx->Sigma);
> >  	memcpy(&ctx->hash, &ctx->h, sizeof(struct streebog_uint512));
> >  }
> >  
> > diff --git a/include/crypto/streebog.h b/include/crypto/streebog.h
> > index 856e32af86574..cae1b4a019713 100644
> > --- a/include/crypto/streebog.h
> > +++ b/include/crypto/streebog.h
> > @@ -23,7 +23,10 @@ struct streebog_uint512 {
> >  };
> >  
> >  struct streebog_state {
> > -	u8 buffer[STREEBOG_BLOCK_SIZE];
> > +	union {
> > +		u8 buffer[STREEBOG_BLOCK_SIZE];
> > +		struct streebog_uint512 m;
> > +	};
> >  	struct streebog_uint512 hash;
> >  	struct streebog_uint512 h;
> >  	struct streebog_uint512 N;
> > -- 
> > 2.21.0
