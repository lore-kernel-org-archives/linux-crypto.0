Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4787FC4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Nov 2022 10:55:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbiKVKzz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Nov 2022 05:55:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231998AbiKVKzy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2022 05:55:54 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047802AC71
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2022 02:55:52 -0800 (PST)
Received: from [192.168.1.23] (unknown [94.229.32.126])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: andrewsh)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 245466602A81;
        Tue, 22 Nov 2022 10:55:51 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.co.uk;
        s=mail; t=1669114551;
        bh=+1vAo0LerH8wsSi//WtJnv0ojvgK+Hdwpy7A1HfsRAk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=q0QZXbv/ZEQcZqNjJv+869sA4cHbkcsFhQ7rDQWcbgrojTzrh0wSnWWnvYZLEFBpA
         yeqeQuck5I6CDSXbnGiBMtW2VWoVa5gh6mLaOQfR9EvsWgtt1DM9UTDctrX7wTx/jM
         OpeH2nbgiRtfWcn9kvoKIKSabRfryp+3YM9C7M8qP0CsrZSOp9tRRD/K3UAafVACv3
         03iUT0z6Jck7b8x+o+DFwfoe5J1okqOodfCZCn5bQXiZfzP6BJoNvu0UzQ/D8pHV1u
         TgunhTq4fLIfQqwwdpEDTPcVivLltceo+88ebxeR9gfVho3CDDRo9d/3K4Uh3sX17l
         dvLOZ1/b3hBcw==
Message-ID: <2b70efb3-08ef-8de0-d222-4bc29288dde8@collabora.co.uk>
Date:   Tue, 22 Nov 2022 11:55:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.1
Subject: Re: [PATCH] hwrng: u2fzero - account for high quality RNG
Content-Language: en-GB
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc:     Jiri Kosina <jkosina@suse.cz>
References: <20221119134259.2969204-1-Jason@zx2c4.com>
From:   Andrej Shadura <andrew.shadura@collabora.co.uk>
Organization: Collabora
In-Reply-To: <20221119134259.2969204-1-Jason@zx2c4.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 19/11/2022 14:42, Jason A. Donenfeld wrote:
> The U2F zero apparently has a real TRNG in it with maximum quality, not
> one with quality of "1", which was likely a misinterpretation of the
> field as a boolean. So remove the assignment entirely, so that we get
> the default quality setting.
> 
> In the u2f-zero firmware, the 0x21 RNG command used by this driver is
> handled as such [1]:

> So it seems rather plain that the ATECC RNG is considered to provide
> good random numbers.

Thanks — at the time when it was written, there was a general concern 
about whether we should trust the hardware RNG of this device or not, so 
the safer option was not to :)

> Cc: Andrej Shadura <andrew.shadura@collabora.co.uk>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Probably too late, but still:

Acked-by: Andrej Shadura <andrew.shadura@collabora.co.uk>

-- 
Cheers,
   Andrej

