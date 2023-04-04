Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD82C77B6E
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Apr 2023 08:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbjDDI7S (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Apr 2023 04:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234037AbjDDI7Q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Apr 2023 04:59:16 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0AC10E3
        for <linux-crypto@vger.kernel.org>; Tue,  4 Apr 2023 01:59:13 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id t4so26728132wra.7
        for <linux-crypto@vger.kernel.org>; Tue, 04 Apr 2023 01:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680598751;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xhmLvYTQcPKtQRpKNvJ99GQcivVXlt+ZGDjfmFboqdY=;
        b=iFuBFInAqwNQveiwRZUKoUptD7VgxIu2xXvn5sA1OBeDBNJFH6cmXnD8fAcjC/iM5+
         vsqGz3Ce9igGibAd0w5FaLhXs+92iaV6NpVjom8jVtydnyU8TEeNVOHf6M/mnmPG6sdI
         XYqlCKhrRwCDd8P4hivhShtLOmsNSAHgsJ8daVq2urAiXXEyFIpLQ7vAlvXbqZAtUyTb
         fXYat8OuoA8JirQAhzqxHKWKa4qaRuaZUIENvcDbGMDPBHR8anDYKW+ljM4B7WUwAbDe
         qJKIjCWAtRoKZ07YGdwRi+W6VjU1ZrPPQx1zqZpsRFCwRkd3GsQsRlZBz+K+cnFiyg1p
         gN1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680598751;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xhmLvYTQcPKtQRpKNvJ99GQcivVXlt+ZGDjfmFboqdY=;
        b=d21mi3oZtQXs3MkxbvutQgFBMKBP0yJCLZdOY9sMOpBVzHYP4bVMTG8kTQSx/WpXK5
         tZsf3Ql+SzmhzKmqqQ9GcNlO3DcOd/1ikfw1lZ9wcMlTUNDejrhevg9mdyFR7d33ls6R
         jG+eTkgsllsB1xrR5q+XQ7b3ASNbq4u6uJdNFpLMqsHDTrZiVknWCvd8UYVj+3nPEPW5
         5b0twWFlLnH2Z8r1HzEo9s/6qrF0ecuHBtvu8oEM1W2mrNBymyRH0hueIi18OJjOx/tn
         xj6Zk43NLhtoSLJQRaShLJuLfb45ueTOASGTM8k75kw8oVfUGATdUSvI9cc7eJ7V3R9I
         Hdrg==
X-Gm-Message-State: AAQBX9etrqUAtf0Xe+Bvq6bMGZBq/d9WqKHeLe0Fq7hLPAObvn3chpQo
        EYmrLIE72grHeOqtPDHn725YkQ==
X-Google-Smtp-Source: AKy350bTPANrZCQfItZxB//61A8/dpTItubB+xmFkueFRy36gzr1xtKT50DBcvGfsbByv9g2a/nkgA==
X-Received: by 2002:adf:f786:0:b0:2e5:151e:89f1 with SMTP id q6-20020adff786000000b002e5151e89f1mr1163239wrp.8.1680598751583;
        Tue, 04 Apr 2023 01:59:11 -0700 (PDT)
Received: from linaro.org ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id u13-20020adfeb4d000000b002daeb108304sm11777978wrn.33.2023.04.04.01.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 01:59:11 -0700 (PDT)
Date:   Tue, 4 Apr 2023 11:59:09 +0300
From:   Abel Vesa <abel.vesa@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v5 2/6] dt-bindings: ufs: qcom: Add ICE phandle
Message-ID: <ZCvm3fzSh8owVDdc@linaro.org>
References: <20230403200530.2103099-1-abel.vesa@linaro.org>
 <20230403200530.2103099-3-abel.vesa@linaro.org>
 <9fc90c8b-9234-84fa-7dab-fee9de2b9813@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9fc90c8b-9234-84fa-7dab-fee9de2b9813@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 23-04-04 07:41:55, Krzysztof Kozlowski wrote:
> On 03/04/2023 22:05, Abel Vesa wrote:
> > Starting with SM8550, the ICE will have its own devicetree node
> > so add the qcom,ice property to reference it.
> > 
> > Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
> > ---
> > 
> > The v4 is here:
> > https://lore.kernel.org/all/20230327134734.3256974-4-abel.vesa@linaro.org/
> > 
> > Changes since v4:
> >  * Added check for sm8550 compatible w.r.t. qcom,ice in order to enforce
> >    it while making sure none of the other platforms are allowed to use it
> 
> Why?

SM8550 will be the first platform to use the new DT bindings w.r.t ICE.

> 
> Also, this does not solve my previous question still.

Well, the clocks are not added for the a few platforms (which include
SM8550). Same for 'ice' reg range.. So the only thing left is to
enforce the qcom,ice property availability only for SM8550. I believe
it solves the mutual exclusiveness of the "ice" reg range along with the
clocks versus the qcom,ice property, by enforcing at compatible level.

Is this not enough?

> 
> Best regards,
> Krzysztof
> 
