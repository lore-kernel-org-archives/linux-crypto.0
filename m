Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBDF8C4332F
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Nov 2022 11:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbiKHLor (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Nov 2022 06:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233591AbiKHLoq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Nov 2022 06:44:46 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3611145C
        for <linux-crypto@vger.kernel.org>; Tue,  8 Nov 2022 03:44:44 -0800 (PST)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 578A5660299E;
        Tue,  8 Nov 2022 11:44:43 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1667907883;
        bh=W27GwajM1JOShA2bOAOvEhFw/+XjuzI+X/RVt0CnqzY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=n1+RTtOCaHOyHADCOxI3mJaDsIhGvgt5X32xwxWvHvQiLc4T/Huqy5l/kRl5S+c11
         TKf4oSL3UgXwRpkz1vCFOKttdu6wkdGQsPLhgsLMYacT7igXVNfuv1h7kN0FmVh1De
         JG5zMfw0Vd5yzO/usIgomJY0jOX33Eid0V5CGnaKHA8Adeu0OcfGwl4DBlmJculsLz
         5SOoMwkEKjHF/aQBq/jOqPBgZXfSfSaAGzuXS4kyn6mW+08vBPh56GvRInBA3pjNsA
         4l287eay8BsEPPjGg/6lP1gZxykyj52CkVV/LRgBK1wT6Ba1H4ECcoWqEKVWbNh9KP
         W+bkJyrdaox6w==
Message-ID: <76971346-73bf-f9b8-3434-f06ef991f328@collabora.com>
Date:   Tue, 8 Nov 2022 12:44:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v4] hw_random: use add_hwgenerator_randomness() for early
 entropy
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc:     Dominik Brodowski <linux@dominikbrodowski.net>
References: <Y2o22ODqUZNO4NsR@zx2c4.com>
 <20221108112413.199669-1-Jason@zx2c4.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20221108112413.199669-1-Jason@zx2c4.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Il 08/11/22 12:24, Jason A. Donenfeld ha scritto:
> Rather than calling add_device_randomness(), the add_early_randomness()
> function should use add_hwgenerator_randomness(), so that the early
> entropy can be potentially credited, which allows for the RNG to
> initialize earlier without having to wait for the kthread to come up.
> 
> This requires some minor API refactoring, by adding a `sleep_after`
> parameter to add_hwgenerator_randomness(), so that we don't hit a
> blocking sleep from add_early_randomness().
> 
> Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

On MT8192 Asurada, MT8195 Tomato Chromebooks:
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

Thanks for the fast fix!

Regards,
Angelo
