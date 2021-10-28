Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A539C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Oct 2021 21:25:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4454561056
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Oct 2021 21:25:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhJ1V1o (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Oct 2021 17:27:44 -0400
Received: from mail-ot1-f47.google.com ([209.85.210.47]:35479 "EHLO
        mail-ot1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbhJ1V1n (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Oct 2021 17:27:43 -0400
Received: by mail-ot1-f47.google.com with SMTP id w12-20020a056830410c00b0054e7ceecd88so10591074ott.2;
        Thu, 28 Oct 2021 14:25:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tiWqCEn8GVN6UBWr5phHaRf5bXgt8msHGMp/4TnSjNM=;
        b=C/Q06E8fxxNQ0e+eOGZVLl3U9u1SYjPefDX0mS6Ik7z1Yhw1ze0zs4ZHmV+QkR+2Hz
         ZCfo/1ok7uf51TfwLBMhBLzHoHajlsrDTLkgz+WmMgV/s/MXaLTsi22PgcZG2kn5k08U
         7yujymB30nz0o/2TD36j3ZUmRsDhBrV4ctP70Xz+Prf7nwJUFmaNHJ9sRj0DjCS7DpY0
         DFpIr3+c9rWSin2R0Frj5YpTG28NlIT0YJbWewZwWpzl1GTt0S8zc5UzqhgN0Y1b9HPL
         o6ax4ptOF5/9Tm0RYrR18YpCeqQm1MipYHeiPjy3BUN+Kq6NkQ5/jA+aouYp9fJduZHN
         YokQ==
X-Gm-Message-State: AOAM532mY3zDbi8yg5K49RjAvsSaxCvIdms2gd7lAihz9sUGLqTAjL6v
        MB90Co1X3RZpH2dwqmMPPw==
X-Google-Smtp-Source: ABdhPJwr4ALYGEgcbmKgY/ZDGTsvVBvtKq6AjaPF/9/DxFue2vlljC9/s2Au2mAtmwvzNHo0RzeNew==
X-Received: by 2002:a05:6830:1c2f:: with SMTP id f15mr5524183ote.63.1635456315658;
        Thu, 28 Oct 2021 14:25:15 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id l5sm662812otq.64.2021.10.28.14.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 14:25:14 -0700 (PDT)
Received: (nullmailer pid 613028 invoked by uid 1000);
        Thu, 28 Oct 2021 21:25:14 -0000
Date:   Thu, 28 Oct 2021 16:25:14 -0500
From:   Rob Herring <robh@kernel.org>
To:     Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
Cc:     linux-crypto@vger.kernel.org,
        Elena Reshetova <elena.reshetova@intel.com>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Prabhjot Khurana <prabhjot.khurana@intel.com>,
        devicetree@vger.kernel.org, Mark Gross <mgross@linux.intel.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Subject: Re: [PATCH 4/5] dt-bindings: crypto: Add Keem Bay ECC bindings
Message-ID: <YXsVOlB6B7PUFixR@robh.at.kernel.org>
References: <20211020103538.360614-1-daniele.alessandrelli@linux.intel.com>
 <20211020103538.360614-5-daniele.alessandrelli@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211020103538.360614-5-daniele.alessandrelli@linux.intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 20 Oct 2021 11:35:37 +0100, Daniele Alessandrelli wrote:
> From: Prabhjot Khurana <prabhjot.khurana@intel.com>
> 
> Add Keem Bay Offload and Crypto Subsystem (OCS) Elliptic Curve
> Cryptography (ECC) device tree bindings.
> 
> Signed-off-by: Prabhjot Khurana <prabhjot.khurana@intel.com>
> Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
> ---
>  .../crypto/intel,keembay-ocs-ecc.yaml         | 47 +++++++++++++++++++
>  MAINTAINERS                                   |  7 +++
>  2 files changed, 54 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/intel,keembay-ocs-ecc.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
