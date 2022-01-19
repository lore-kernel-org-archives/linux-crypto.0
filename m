Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D108C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jan 2022 10:06:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353031AbiASKGU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Jan 2022 05:06:20 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:48710 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1352594AbiASKGT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jan 2022 05:06:19 -0500
X-UUID: 6f0487ea9b324649a36e3cef157eea4b-20220119
X-UUID: 6f0487ea9b324649a36e3cef157eea4b-20220119
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <miles.chen@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 807312107; Wed, 19 Jan 2022 18:06:16 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 19 Jan 2022 18:06:15 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 19 Jan 2022 18:06:15 +0800
From:   Miles Chen <miles.chen@mediatek.com>
To:     <jason@zx2c4.com>
CC:     <ardb@kernel.org>, <davem@davemloft.net>,
        <gregkh@linuxfoundation.org>, <herbert@gondor.apana.org.au>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <matthias.bgg@gmail.com>,
        <miles.chen@mediatek.com>, <nathan@kernel.org>,
        <ndesaulniers@google.com>
Subject: Re: [PATCH] lib/crypto: blake2s: fix a CFI failure
Date:   Wed, 19 Jan 2022 18:06:15 +0800
Message-ID: <20220119100615.5059-1-miles.chen@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <CAHmME9oX+4Ek81xy0nBOegqABH0xYqyONAqinsu7GZ7AaQaqYQ@mail.gmail.com>
References: <CAHmME9oX+4Ek81xy0nBOegqABH0xYqyONAqinsu7GZ7AaQaqYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

>Hi Miles,
>
>I'm actually not able to reproduce your oops. I'm using vanilla clang
>13, cross compiling for arm64, with thin LTO enabled and CFI enabled.
>Kernel seems to run fine.
>
>
>Are there other settings that are needed to trigger this? Do you see
>it in upstream clang or just the Android fork of clang?
>
I will try another clang (the previous version I use).
I am using Android fork of clang and there is a clang upgrade in this merge.

Miles

