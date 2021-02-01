Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34103C433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 20:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D324064ECE
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 20:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhBAUsM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Feb 2021 15:48:12 -0500
Received: from 3.mo5.mail-out.ovh.net ([46.105.40.108]:59895 "EHLO
        3.mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhBAUsL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Feb 2021 15:48:11 -0500
X-Greylist: delayed 5400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Feb 2021 15:48:10 EST
Received: from player734.ha.ovh.net (unknown [10.108.42.142])
        by mo5.mail-out.ovh.net (Postfix) with ESMTP id 5702F2A8642
        for <linux-crypto@vger.kernel.org>; Mon,  1 Feb 2021 19:52:47 +0100 (CET)
Received: from 3mdeb.com (85-222-117-222.dynamic.chello.pl [85.222.117.222])
        (Authenticated sender: maciej.pijanowski@3mdeb.com)
        by player734.ha.ovh.net (Postfix) with ESMTPSA id B0DF51A77D473;
        Mon,  1 Feb 2021 18:52:43 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-102R004460a934a-3a1d-4d9a-961c-5b89bb1c55ce,
                    ACE63DF45BB0D0C5B239E883FB7766019137A65F) smtp.auth=maciej.pijanowski@3mdeb.com
X-OVh-ClientIp: 85.222.117.222
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, pascalvanl@gmail.com,
        =?UTF-8?Q?Piotr_Kr=c3=b3l?= <piotr.krol@3mdeb.com>
From:   Maciej Pijanowski <maciej.pijanowski@3mdeb.com>
Subject: safexcel driver for EIP197 and mini firmware features
Message-ID: <d90956cf-5340-cbe4-1254-771c18b7e46d@3mdeb.com>
Date:   Mon, 1 Feb 2021 19:52:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Ovh-Tracer-Id: 5620210864125980364
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -83
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgdduudekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnegfrhhlucfvnfffucdludejmdenucfjughrpefvhffukffffgggtgfgsehtjeertddtfeejnecuhfhrohhmpeforggtihgvjhcurfhijhgrnhhofihskhhiuceomhgrtghivghjrdhpihhjrghnohifshhkihesfehmuggvsgdrtghomheqnecuggftrfgrthhtvghrnhepfefhfeetjefffedvudeftddtfedttdfhffeludefteelieeiveeggeduvddvvefgnecuffhomhgrihhnpehsohhlihguqdhruhhnrdgtohhmpdhsohhlihguqdgsuhhilhgurdighiiipdhkvghrnhgvlhdrohhrghdpfehmuggvsgdrtghomhenucfkpheptddrtddrtddrtddpkeehrddvvddvrdduudejrddvvddvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepphhlrgihvghrjeefgedrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehmrggtihgvjhdrphhijhgrnhhofihskhhiseefmhguvggsrdgtohhmpdhrtghpthhtoheplhhinhhugidqtghrhihpthhosehvghgvrhdrkhgvrhhnvghlrdhorhhg
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

I am interested in using the EIP197 crypto accelerator. I am aware that 
it requires an NDA
to obtain the firmware for it, but I found out that there is some kind 
of "minifw" as well
in the linux-firmware tree [3]. I found no description of it - I would 
like to learn what
are the features and limitations of this "minifw".

I started with using it on the Debian image from board vendor [2]. The 
kernel here is
5.1.0. The firmware is loaded, but the ALG tests are all failing:

[14785.750246] crypto-safexcel f2800000.crypto: firmware: direct-loading 
firmware inside-secure/eip197b/ifpp.bin
[14785.762765] crypto-safexcel f2800000.crypto: firmware: direct-loading 
firmware inside-secure/eip197b/ipue.bin
[14785.777978] alg: skcipher: safexcel-cbc-des encryption test failed 
(wrong output IV) on test vector 0, cfg="in-place"
[14785.788661] 00000000: fe dc ba 98 76 54 32 10
[14785.800606] alg: skcipher: safexcel-cbc-des3_ede encryption test 
failed (wrong output IV) on test vector 0, cfg="in-place"
[14785.811720] 00000000: 7d 33 88 93 0f 93 b2 42
[14785.823734] alg: skcipher: safexcel-cbc-aes encryption test failed 
(wrong output IV) on test vector 0, cfg="in-place"
[14785.834439] 00000000: 3d af ba 42 9d 9e b4 30 b4 22 da 80 2c 9f ac 41
[14785.884568] alg: hash: safexcel-hmac-sha224 test failed (wrong 
result) on test vector 3, cfg="init+update+update+final two even splits"
[14785.901836] alg: hash: safexcel-hmac-sha256 test failed (wrong 
result) on test vector 2, cfg="import/export"
[14785.926693] alg: aead: safexcel-authenc-hmac-sha1-cbc-aes encryption 
test failed (wrong result) on test vector 0, cfg="misaligned splits 
crossing pages, inplace"
[14785.944430] alg: No test for authenc(hmac(sha224),cbc(aes)) 
(safexcel-authenc-hmac-sha224-cbc-aes)
[14785.956978] alg: aead: safexcel-authenc-hmac-sha256-cbc-aes 
encryption test failed (wrong result) on test vector 0, cfg="two even 
aligned splits"
[14785.973472] alg: No test for authenc(hmac(sha384),cbc(aes)) 
(safexcel-authenc-hmac-sha384-cbc-aes)
[14785.986103] alg: aead: safexcel-authenc-hmac-sha512-cbc-aes 
encryption test failed (wrong result) on test vector 0, cfg="two even 
aligned splits"


I am going to test it with more recent, mainline kernel as well, but it 
would be still nice to learn
a little bit more about this "minifw", it's features, and what could be 
possibly achieved on this
board without proprietary (and behind NDA) crypto firmware.

Thank you,


[1] 
https://www.solid-run.com/embedded-networking/marvell-armada-family/clearfog-gt-8k/
[2] https://images.solid-build.xyz/8040/Debian/
[3] 
https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/commit/inside-secure/eip197_minifw/ifpp.bin?id=eefb5f7410150c00d0ab5c41c5d817ae9bf449b3

-- 
Maciej Pijanowski
Embedded Systems Engineer
GPG: 9963C36AAC3B2B46
https://3mdeb.com | @3mdeb_com

