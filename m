Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F1FC636CD
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Jan 2023 16:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbjA0Qtd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Jan 2023 11:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234368AbjA0Qt3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Jan 2023 11:49:29 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBD67E04E
        for <linux-crypto@vger.kernel.org>; Fri, 27 Jan 2023 08:49:18 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id m5-20020a05600c4f4500b003db03b2559eso3919272wmq.5
        for <linux-crypto@vger.kernel.org>; Fri, 27 Jan 2023 08:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MwxIin163802ACvSCq0jg4HlDZfjOU+b7ag/1i6mXEE=;
        b=p0bN2yAu28MNGvTlRbQWr0+f8dRrN7+Tn627u0K/x42EmNDLphayIf9NlMev0wqj8h
         /EmzHfmLQqKOVu8ZgIciDK/fUJr6PvWPKCTqRsZtsPxIDrQvOH3aJeQUvnun7rNkTSUQ
         6/KZMhpjpBCdTsrlPk0Pq1AqbefuhemfseqENDs+CCppSNm6HT2vKHwFAalheOqTayxm
         dtjoNuM92e8Dp5V+KrvfMQYfpqoVE/fUi7G9DPER5YIOirUmedqSV5KeWbBKvr23C7Je
         C0hL4yNzr1apQ8T4Xaqa5bA4xfUJep3aF5qWXf5H1dWiQl4NI8yI1oLJqFFQ+XguiBLe
         Z84Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MwxIin163802ACvSCq0jg4HlDZfjOU+b7ag/1i6mXEE=;
        b=7p4zS5rZMWCS8SW9b5oDx9HzPwaT95kXj45equdAZVFcaTFkGrmSbogLRgTq051a/u
         SuovuKFdy6RjLXWVQX+HADVPJXV8GU2OYQde6YAlXPtezRj77akuM2HX7W7PwmfX1idn
         KpgN4gTtWUBzJRg0yj1PeqB0uEaSi6BPYpMas7FQcqoPg0wNUZsl11t7VQ9a+5ZQVMB5
         eQMZ3THPmep1ZJ5/CU28TEHbbTuq8B9nGq8dY7saN72nhPEKe0lS49uUjsYRGyom5yS5
         QgBlqUxRk3FkkfRzGX63CA3vwB79O3LeF9LOYeUuxHLfmKt/nU2PhS+frmUuD7htPyQD
         txJg==
X-Gm-Message-State: AO0yUKWNZFlPUhgQ9PW3F7z2Y9hVbiFl6MqIbpy1KJpUz1uYC+plTSDt
        8T2P1hQWPdEyM3vgk19wGFHsZg==
X-Google-Smtp-Source: AK7set91BwRn6DZssbXKyvbz30nnUQMYADbkS+Drm/RA9jZHFwp9Oe0M3rmb1c4Tgb8gUCp8+I209g==
X-Received: by 2002:a05:600c:3151:b0:3dc:443e:420e with SMTP id h17-20020a05600c315100b003dc443e420emr40585wmo.2.1674838156833;
        Fri, 27 Jan 2023 08:49:16 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id p24-20020a05600c1d9800b003dafadd2f77sm8990779wms.1.2023.01.27.08.49.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 08:49:16 -0800 (PST)
Message-ID: <1e498b93-d3bd-bd12-e991-e3f4bedf632d@linaro.org>
Date:   Fri, 27 Jan 2023 17:49:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 1/6] dt-bindings: Document common device controller
 bindings
Content-Language: en-US
To:     Gatien Chevallier <gatien.chevallier@foss.st.com>,
        Oleksii_Moisieiev@epam.com, gregkh@linuxfoundation.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        alexandre.torgue@foss.st.com, vkoul@kernel.org, jic23@kernel.org,
        olivier.moysan@foss.st.com, arnaud.pouliquen@foss.st.com,
        mchehab@kernel.org, fabrice.gasnier@foss.st.com,
        ulf.hansson@linaro.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-iio@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org
References: <20230127164040.1047583-1-gatien.chevallier@foss.st.com>
 <20230127164040.1047583-2-gatien.chevallier@foss.st.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230127164040.1047583-2-gatien.chevallier@foss.st.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 27/01/2023 17:40, Gatien Chevallier wrote:
> From: Oleksii Moisieiev <Oleksii_Moisieiev@epam.com>
> 
> Introducing of the common device controller bindings for the controller
> provider and consumer devices. Those bindings are intended to allow
> divided system on chip into muliple domains, that can be used to
> configure hardware permissions.
> 
> Signed-off-by: Oleksii Moisieiev <oleksii_moisieiev@epam.com>
> ---
> 
> No change since V1. I'm letting this patch for dependency with bindings to
> avoid noise with dt/bindings checks. Therefore, it should be reviewed on the
> appropriate thread.

There was a v6 already, this is v3 and I don't understand this comment.
What do you let? Whom? If it is not for review and not for merging,
please annotate it in the title ([IGNORE PATCH] or something).

Best regards,
Krzysztof

