Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B60C06511
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 15:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C258F2082F
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 15:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562082824;
	bh=H9aGzcRIAF8z4znsY082TkkEBo8mLXRjkdpeEtNj/VE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=P7myPV3tV4h9ffHnjnM2KEkTn2GQUEh2/yR+bUiQPK+4ItMSjHlyUZ3BiCsTn3Ua+
	 FWWjBfH3HUn2piJ9q7iQuAQbaYpPehz7P8S38poSFijttpnludtq340Op/cu4ac3G5
	 7n9TJEfG5msJ8iw/Ft8thBh+9Md0mTQSUHdgIXj0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfGBPxn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 11:53:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbfGBPxk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 11:53:40 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C1E42082F;
        Tue,  2 Jul 2019 15:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562082819;
        bh=H9aGzcRIAF8z4znsY082TkkEBo8mLXRjkdpeEtNj/VE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GQyZzmZt+hAFbRuIk9/PKT9lT2fPlVjgT/gP4qos5EpIEGEgKjNF1290flNniLpBB
         jUYizh3qkyO9Ksv+gk14yXnADZBxYDO2dnGlDns6fDwXFH6WWK+/laPgUv0xrCGcjn
         66Torw3LgSM0m78lPcZdICvQm4e4NiR+B8veDoUw=
Date:   Tue, 2 Jul 2019 08:53:37 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gary R Hook <ghook@amd.com>
Cc:     Cfir Cohen <cfir@google.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: ccp/gcm - use const time tag comparison.
Message-ID: <20190702155337.GA895@sol.localdomain>
References: <20190702000132.88836-1-cfir@google.com>
 <20190702002522.GA693@sol.localdomain>
 <1eea04e4-ac19-241d-695b-61be43640509@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1eea04e4-ac19-241d-695b-61be43640509@amd.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 02, 2019 at 03:41:23PM +0000, Gary R Hook wrote:
> On 7/1/19 7:25 PM, Eric Biggers wrote:
> > On Mon, Jul 01, 2019 at 05:01:32PM -0700, Cfir Cohen wrote:
> >> Avoid leaking GCM tag through timing side channel.
> >>
> >> Signed-off-by: Cfir Cohen <cfir@google.com>
> >> ---
> >>   drivers/crypto/ccp/ccp-ops.c | 3 ++-
> >>   1 file changed, 2 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> >> index db8de89d990f..633670220f6c 100644
> >> --- a/drivers/crypto/ccp/ccp-ops.c
> >> +++ b/drivers/crypto/ccp/ccp-ops.c
> >> @@ -840,7 +840,8 @@ static int ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q,
> >>   		if (ret)
> >>   			goto e_tag;
> >>   
> >> -		ret = memcmp(tag.address, final_wa.address, AES_BLOCK_SIZE);
> >> +		ret = crypto_memneq(tag.address, final_wa.address,
> >> +				    AES_BLOCK_SIZE) ? -EBADMSG : 0;
> >>   		ccp_dm_free(&tag);
> >>   	}
> >>   
> >> -- 
> >> 2.22.0.410.gd8fdbe21b5-goog
> >>
> > 
> > Looks like this needs:
> > 
> > 	Fixes: 36cf515b9bbe ("crypto: ccp - Enable support for AES GCM on v5 CCPs")
> > 	Cc: <stable@vger.kernel.org> # v4.12+
> 
> 
> Yes, it does. For clarity, does that mean you've taken care of this?
> 

Herbert is the person who will apply this, so he'd need to do it.  But it might
be better just to resend.

- Eric
