From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] crypto: AF_ALG - inline IV support
Date: Sun, 21 Jan 2018 13:14:30 +0100
Message-ID: <2165621.DHQGk8sIp3@positron.chronox.de>
References: <2118226.LQArbCsRu5@tauon.chronox.de> <1972650.zFSS3VNpIS@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, harsh@chelsio.com,
        jonathan.cameron@huawei.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:57948 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751019AbeAUMOc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Jan 2018 07:14:32 -0500
In-Reply-To: <1972650.zFSS3VNpIS@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

I tried to summarize the use cases of the AIO support at [1].

The use case covering the inline IV support is documented in section [2]. It 
naturally would depend on this patch to be accepted. What is your take on this 
use case?

What is your take on the issue outlined at [3]? Should the affected drivers be 
updated?

Thanks
Stephan

[1] https://github.com/smuellerDD/libkcapi/commit/
29132075b8f045f3f92367c0190add81ccf5da11

[2] https://github.com/smuellerDD/libkcapi/commit/
29132075b8f045f3f92367c0190add81ccf5da11#diff-
dce7a00cbc610df94f0dc27eb769d01dR644

[3] https://github.com/smuellerDD/libkcapi/commit/
29132075b8f045f3f92367c0190add81ccf5da11#diff-
dce7a00cbc610df94f0dc27eb769d01dR575
