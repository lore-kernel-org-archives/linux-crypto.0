Return-Path: <SRS0=sx3D=ZG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE720C43141
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 18:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 804DF2071B
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 18:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573756092;
	bh=sNbV3B2yEXkGodqc4OskFrEkZQIL3OgiUqovzmlNxZ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=GwkX+fA29UPUpIkGMKY2feXwOdWJ2E7/382T5rws8TH942kAhLwFLJ1sfdokVDJxC
	 6ShnAc7I4O8epR2/EmC4/r9490cGshYa4hJ4wPYFc/2/Y32txMVABJf7Wu7V2Yjj/4
	 WmA5l0v7SfXlQQYNhWYXOBjNYUIiWPTKwXKq/XR0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfKNS2L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Nov 2019 13:28:11 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:43142 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbfKNS2L (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Nov 2019 13:28:11 -0500
Received: by mail-ot1-f66.google.com with SMTP id l14so5710691oti.10;
        Thu, 14 Nov 2019 10:28:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=c57kRuz/wdX2ojYongufIJZjkHTf4M0B8KckeBCmq7w=;
        b=qohccxFV4kB91qbhv/0semqXthzDCacu0MMhB9QMASWAG8So224Zvc+8gAySNq+HIY
         aWy08A9pTdkRDykq3FKSf9X94dMOMylXoOR5DgyjV87eLq+myxQjFxlE+V4yNo8N8UWA
         6FCsLufnK/o16Nvxck2X13V4IeeOImr9J8vtP6Nvthnlr+xJqV0LMNP95oIasSxmFuRe
         oRiPHwaCIQwTxxjuwAEUsNK3BHB7ab8kJYbW1ikvd4M/46ofkvQ7jeFTF9lITzqcKo2O
         kkOV+QoiDkjrPegVeK5/YEsWXOfiX6xeZXIA8HbjSNu41x7r8z9lXBih+itB4/ceY323
         NzAg==
X-Gm-Message-State: APjAAAUmx46JVV7mwLIvr01AY++s7yVavmQvO1b3ebTCL1UZfv18VeoU
        2oIKQhxJp5Lio38mCo8qiqwqqz8=
X-Google-Smtp-Source: APXvYqydePYwxykYh+8rFhhUMjHqM+gGBXZEGQ9HgBhBBB8gZBssUBQF6b95aeyrt6SvCfQneJ6Vng==
X-Received: by 2002:a05:6830:11cf:: with SMTP id v15mr8083572otq.36.1573756089672;
        Thu, 14 Nov 2019 10:28:09 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id l20sm1948314oii.26.2019.11.14.10.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 10:28:09 -0800 (PST)
Date:   Thu, 14 Nov 2019 12:28:08 -0600
From:   Rob Herring <robh@kernel.org>
To:     Benjamin Gaignard <benjamin.gaignard@st.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, alexandre.torgue@st.com,
        lionel.debieve@st.com, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@st.com>
Subject: Re: [PATCH] dt-bindings: crypto: Convert stm32 CRYP bindings to
 json-schema
Message-ID: <20191114182808.GA29513@bogus>
References: <20191108125244.23001-1-benjamin.gaignard@st.com>
 <20191108125244.23001-2-benjamin.gaignard@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108125244.23001-2-benjamin.gaignard@st.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 8 Nov 2019 13:52:43 +0100, Benjamin Gaignard wrote:
> Convert the STM32 CRYP binding to DT schema format using json-schema
> 
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
> ---
>  .../devicetree/bindings/crypto/st,stm32-cryp.txt   | 19 --------
>  .../devicetree/bindings/crypto/st,stm32-cryp.yaml  | 51 ++++++++++++++++++++++
>  2 files changed, 51 insertions(+), 19 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/crypto/st,stm32-cryp.txt
>  create mode 100644 Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml
> 

Applied, thanks.

Rob
