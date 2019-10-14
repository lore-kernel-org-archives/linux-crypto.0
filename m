Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05253ECE587
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 18:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA76A20854
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 18:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571077026;
	bh=LczrQTUyvT5jaLGgcpxF4f3vBKkBDCVyFILFIgjdkEg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=CQZv0WL+j6vrGKdd8GxU5Y/rM3QiWGXw09Z7HS2proK8t+l3G4wBL6m3GkR9R7KKf
	 9VtvJ6shQNKCkNOLoiDl60GfnqMSwJQ9vfm2nVz22+XRsHRj6h4j3EVlj5mVe7gJ8e
	 klKrNCiFTFle4VMMeWFK7lEQrtbZtLfvlpry6lF0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388763AbfJNSRG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 14:17:06 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39920 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731926AbfJNSRG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 14:17:06 -0400
Received: by mail-ot1-f65.google.com with SMTP id s22so14589521otr.6;
        Mon, 14 Oct 2019 11:17:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ckXq7H/VDyEuDBGMiSrOJq+fYS3KZI2dTxrNxPrWB1k=;
        b=mV9KOS5bzFNCpLJWeZlhoj5fUuoEyVYCR4kPOoqcfkZfGyFnk0CYNFh6QLXz1JZk5G
         Or6vPVZt8rcIxJtQgwbZD0Hsi4Kcd6QBoZopXkyZoGKdDeY3N2zA38aa69/fC/rU/ITi
         /tbZr06y6nAvMXov3EffXQn4KnqtUT1cJBHfyNOtiixTM/bxpvPSaHqV85sK/e5edF0A
         fFK5K3zkXE7CUXGvxDGDPqzuOFd/FuuT8QVXoTwLSFI5bKbaqNwYcImzcQtXN3YDtzmC
         LT8jKm+UMa4EKz9Yj4NC7yU+Qj9adoXIDh6Mtq7ueDk3vg4JBSHbjDkmd31PnmywuJiP
         uhEA==
X-Gm-Message-State: APjAAAXSXGjW0E9BEB0p/XyOoqjfSh2EYfmtl0dJjWsNYn4c8RI++j9M
        b4AQF06zqCsbwd6j+F44tg==
X-Google-Smtp-Source: APXvYqykid9kSCG1CYJVW2KOEUFr4Yc+gJ5hvhWeq8D1eMHp1wcYxUdLkGAG0vEh1DCoe19itZwiaw==
X-Received: by 2002:a9d:58cc:: with SMTP id s12mr12635611oth.291.1571077025089;
        Mon, 14 Oct 2019 11:17:05 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id k24sm5352026oic.29.2019.10.14.11.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 11:17:04 -0700 (PDT)
Date:   Mon, 14 Oct 2019 13:17:03 -0500
From:   Rob Herring <robh@kernel.org>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        khilman@baylibre.com, mark.rutland@arm.com, robh+dt@kernel.org,
        martin.blumenstingl@googlemail.com, devicetree@vger.kernel.org,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: Re: [PATCH v2 1/4] dt-bindings: crypto: Add DT bindings
 documentation for amlogic-crypto
Message-ID: <20191014181703.GA14399@bogus>
References: <1571031104-6880-1-git-send-email-clabbe@baylibre.com>
 <1571031104-6880-2-git-send-email-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571031104-6880-2-git-send-email-clabbe@baylibre.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 14 Oct 2019 05:31:41 +0000, Corentin Labbe wrote:
> This patch adds documentation for Device-Tree bindings for the
> Amlogic GXL cryptographic offloader driver.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  .../bindings/crypto/amlogic,gxl-crypto.yaml   | 52 +++++++++++++++++++
>  1 file changed, 52 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
