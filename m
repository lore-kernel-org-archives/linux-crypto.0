Return-Path: <SRS0=5Ot1=SE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26815C4360F
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Apr 2019 16:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9DDA206B6
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Apr 2019 16:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554224273;
	bh=Oxsvpb3SEzZI9fQOHx6WGM/b45sZrLvuQ4lKFDplzyo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=vn+gEvhLNfmuiYr4aTJb3c6/KWAdHawWNgrNMiIB5r5Vmaxw0U+OKMmqCctC00rDE
	 YW4KVFePznIrE7jrLjPXpqUMvV3eDoxLfnml7g0+EGYAp9T28wDPbx+PiRjCrqTTiu
	 dvMdzkXQMc0Fk4CexSFPoUO+eXz+5qa9K9N6qcKQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbfDBQ5v (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Apr 2019 12:57:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbfDBQ5v (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Apr 2019 12:57:51 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1F14206B6;
        Tue,  2 Apr 2019 16:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554224270;
        bh=Oxsvpb3SEzZI9fQOHx6WGM/b45sZrLvuQ4lKFDplzyo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xoG+qidwbmsLcz1rIQtHR9jFzXKlXI0NHfiJqEwupX2o0uXeTISqECJEaO9GZKZyB
         bvikMIel04adxv/otRvLELwaUIoTAH+YwDGuTpI9xBfWzZD/KHhxgwqBVwIgMZJM6b
         qsRz8O6a+JsEjN5J994BhYn64tZGrhX1EUTUm7mE=
Date:   Tue, 2 Apr 2019 09:57:49 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Vitaly Chikunov <vt@altlinux.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [RFC/RFT PATCH 09/18] crypto: streebog - fix unaligned memory
 accesses
Message-ID: <20190402165747.GA13413@gmail.com>
References: <20190331200428.26597-1-ebiggers@kernel.org>
 <20190331200428.26597-10-ebiggers@kernel.org>
 <20190331214717.4erxk2racxphfbha@altlinux.org>
 <20190402161557.lg37muib4qy4az22@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190402161557.lg37muib4qy4az22@altlinux.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 02, 2019 at 07:15:57PM +0300, Vitaly Chikunov wrote:
> > >  
> > >  static void streebog_stage2(struct streebog_state *ctx, const u8 *data)
> > >  {
> > > -	streebog_g(&ctx->h, &ctx->N, data);
> > > +	struct streebog_uint512 m;
> > > +
> > > +	memcpy(&m, data, sizeof(m));
> > > +
> > > +	streebog_g(&ctx->h, &ctx->N, &m);
> > >  
> > >  	streebog_add512(&ctx->N, &buffer512, &ctx->N);
> > > -	streebog_add512(&ctx->Sigma, (const struct streebog_uint512 *)data,
> > > -			&ctx->Sigma);
> > > +	streebog_add512(&ctx->Sigma, &m, &ctx->Sigma);
> > >  }
> > 
> > As I understand, this is the actual fix.
> 
> Probably, even better would be to use CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> to optimize out memcpy() for such architectures.
> 

Having multiple code paths is more error-prone, and contrary to popular belief
you can't break alignment rules without informing the compiler, even when
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS.  See
https://patchwork.kernel.org/cover/10631429/.

If you want to code up something yourself using get_unaligned_le64() or
__attribute__((packed)), that probably would be the way to go.  But for now I
just want to fix it to not cause a test failure.  I don't have any particular
interest in optimizing Streebog myself, especially the C implementation (if you
really cared about performance you'd add an assembly implementation).

- Eric
