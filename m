Return-Path: <SRS0=vn8P=UK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8181C4321A
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 13:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9919E20896
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 13:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbfFKNwJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jun 2019 09:52:09 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:42180 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728344AbfFKNwJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jun 2019 09:52:09 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hahBx-0004mN-Tr; Tue, 11 Jun 2019 15:52:02 +0200
Message-ID: <3c625ea9ab435c35cda6e61d19e21802d9507f13.camel@sipsolutions.net>
Subject: Re: [PATCH v3 2/7] net/mac80211: move WEP handling to ARC4 library
 interface
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
Date:   Tue, 11 Jun 2019 15:51:59 +0200
In-Reply-To: <20190611134750.2974-3-ard.biesheuvel@linaro.org> (sfid-20190611_154757_806931_B0C8789F)
References: <20190611134750.2974-1-ard.biesheuvel@linaro.org>
         <20190611134750.2974-3-ard.biesheuvel@linaro.org>
         (sfid-20190611_154757_806931_B0C8789F)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 2019-06-11 at 15:47 +0200, Ard Biesheuvel wrote:
> 
> +++ b/net/mac80211/mlme.c
> @@ -5038,8 +5038,6 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
>  		auth_alg = WLAN_AUTH_OPEN;
>  		break;
>  	case NL80211_AUTHTYPE_SHARED_KEY:
> -		if (IS_ERR(local->wep_tx_tfm))
> -			return -EOPNOTSUPP;
>  		auth_alg = WLAN_AUTH_SHARED_KEY;

This bit is probably not right, we directly use the WEP functions for
shared key authentication.

johannes

