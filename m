Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90588CA0ECE
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Sep 2023 06:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbjILGj2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Sep 2023 02:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbjILGj2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Sep 2023 02:39:28 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28205E76
        for <linux-crypto@vger.kernel.org>; Mon, 11 Sep 2023 23:39:24 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-31dcf18f9e2so5244006f8f.0
        for <linux-crypto@vger.kernel.org>; Mon, 11 Sep 2023 23:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694500762; x=1695105562; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6qcwi6kxTJhR+/TgoB8rdjDl1NyuqB+Mgf6FMTnsLTE=;
        b=McFwbZ6LbZY2cROgViHN1XZLBGDPdJfvBc5t61ZUo+kGevhvk+ulunSxQ5TsPvpHsp
         GZ9/3kZv6YXMxGf8S/GCq3OzLMvPzUHZ2mHU2OJYwdwy/CJBvehv0YhYwlloYe5DL+sb
         RLI4RuMfbSm3Q0RKRFZC0gC+RHHA6iRnG9p8yKaCiF6DwhcpUwBbVwKCFHKLOG/xloN6
         lpuTqXs/Si7aNwuvDxVyenmP7p1Ms+PmiI02zVQlv6yR/JwOaJsXUwkYeDnFqMIpQ+eX
         zDmdLMbrwwCzdyTi/sLZA+6b7RdN7ofSg+fg62xUKcqhqrPbpKo4TOBZFMk/UsMNUgCy
         dHyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694500762; x=1695105562;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6qcwi6kxTJhR+/TgoB8rdjDl1NyuqB+Mgf6FMTnsLTE=;
        b=ZhEKN3EY7/8OUZzCjF1aoM8yApG20guQ7oGaN2wAlSyPtAeFEEgNCjopiT59ymvfYY
         Ns2+bByfKJT58REAdU7phOj2Ffrufw1nadvzbtEar4kXonJAHHItuww6funNXbAOmF57
         ktfVP50nQFuQdiciDShQR0tvL3yKd3MxUqoH+EI9d+c6W5ZYU4FxGt7PcwDAS/zN+Iz7
         h3QAEKBu8bdcvpWOp9sPwAnKnW9Kp3oVbNXSYnPYM2k7y5q1rcRJf5ZLAX1Lh/UyQkZs
         5N9OCHu6mNhAtHCa5gUM6aK874QXDCXt7dvnkZIVFx245SgsY1R8g0HTvtHv+IDIGz8w
         QSEA==
X-Gm-Message-State: AOJu0YxElwSVmkLZqr8JQk06NGFJ/RQUvz0Ctdn7hTTAPZz23hZXSOQo
        HihBu9PzCSBX/GAeAQ7Zpr6s1g==
X-Google-Smtp-Source: AGHT+IE9EhgxWYP9IQXI+O9vQP40R2keaJWtbd2zvD66D6jJq/9krmYKNdmeNyJU92c9kWwVldWlDw==
X-Received: by 2002:a5d:6510:0:b0:317:ec04:ee0c with SMTP id x16-20020a5d6510000000b00317ec04ee0cmr9809162wru.47.1694500762566;
        Mon, 11 Sep 2023 23:39:22 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id a16-20020a5d4570000000b00317f70240afsm11965035wrc.27.2023.09.11.23.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 23:39:22 -0700 (PDT)
Date:   Tue, 12 Sep 2023 09:39:18 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Longfang Liu <liulongfang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Zaibo Xu <xuzaibo@huawei.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: hisilicon/hpre - Fix a erroneous check after
 snprintf()
Message-ID: <909a0cff-ed2c-4728-81ee-57a5d786f450@moroto.mountain>
References: <73534cb1713f58228d54ea53a8a137f4ef939bad.1693858632.git.christophe.jaillet@wanadoo.fr>
 <ZPaSCOX1F9b36rxV@gondor.apana.org.au>
 <00bdcfec-6cc1-e521-ceaa-d16d6341ca16@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00bdcfec-6cc1-e521-ceaa-d16d6341ca16@wanadoo.fr>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 05, 2023 at 07:27:47AM +0200, Marion & Christophe JAILLET wrote:
> 
> Some debugfs dir of file way be left around. Is it what your are talking
> about?
> 

No debugfs files are left.  There is a remove recursive in
hpre_debugfs_init().

regards,
dan carpenter
