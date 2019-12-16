Return-Path: <SRS0=5TcX=2G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F056C43603
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Dec 2019 18:43:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22A9F21582
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Dec 2019 18:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576521829;
	bh=FUdkr+OPLWWDyM9Dx4t19Xeg6PNkIcmAqo9cEVYfyXE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=GVZ+1lnYNQvDj3t+5WmfpmZ5bufA+Ru/ZMtHM6LNW4t/rubi6YARPLBH68D4Xxgyc
	 NmDK5gcAMJqVJDiYjrwtS49G7dBckw2BfQDq0GRCf1QZHgOMh9o1dvMy72I77Fewbm
	 YNRNfoz4iZ0u4DnadWryg2eLPD1OV0efe7V4vKDE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbfLPSno (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Dec 2019 13:43:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:48582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728487AbfLPSno (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Dec 2019 13:43:44 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A5B6206A5;
        Mon, 16 Dec 2019 18:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576521823;
        bh=FUdkr+OPLWWDyM9Dx4t19Xeg6PNkIcmAqo9cEVYfyXE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j9bJ7HTroYesV3/+qBfFPr1qcAuhNrjNGeCBfNGGSK4jmVmdQF2ndktMMzScLsiAL
         UWrw98OZnkDDcqPVDKFOtL7CKB9oB9xIqQRs92o969wlbiUlozdbfStoT/9H5uH3ub
         5RwoMyeLOswdAVlfEKm4BeQEoW8km491JrDWFlfw=
Date:   Mon, 16 Dec 2019 10:43:42 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chen Zhou <chenzhou10@huawei.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: remove unneeded semicolon
Message-ID: <20191216184341.GE139479@gmail.com>
References: <20191216105848.10669-1-chenzhou10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216105848.10669-1-chenzhou10@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Dec 16, 2019 at 06:58:48PM +0800, Chen Zhou wrote:
> Fixes coccicheck warning:
> 
> ./include/linux/crypto.h:573:2-3: Unneeded semicolon
> 
> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
> ---
>  include/linux/crypto.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
> index 23365a9..5446efe 100644
> --- a/include/linux/crypto.h
> +++ b/include/linux/crypto.h
> @@ -570,7 +570,7 @@ static inline int crypto_wait_req(int err, struct crypto_wait *wait)
>  		reinit_completion(&wait->completion);
>  		err = wait->err;
>  		break;
> -	};
> +	}
>  
>  	return err;
>  }
> -- 

As long as you're changing this, perhaps also change the 'switch' to an 'if' and
delete the extra blank line?  I.e.:

static inline int crypto_wait_req(int err, struct crypto_wait *wait)
{
	if (err == -EINPROGRESS || err == -EBUSY) {
		wait_for_completion(&wait->completion);
		reinit_completion(&wait->completion);
		err = wait->err;
	}
	return err;
}
