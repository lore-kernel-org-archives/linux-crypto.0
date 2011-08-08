From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [PATCH v2 2/2] crypto, x86: SSSE3 based SHA1 implementation for x86-64
Date: Mon, 8 Aug 2011 14:07:36 +0800
Message-ID: <CACXcFmnK5QAE9vLS0b7wqGPmMg2bNR7j07fEP_4cyTDeb5q6bg@mail.gmail.com>
References: <1311529994-7924-1-git-send-email-minipli@googlemail.com>
	<1311529994-7924-3-git-send-email-minipli@googlemail.com>
	<20110804064436.GA16247@gondor.apana.org.au>
	<CA+rthh_nx2bvM71M=AdUuhEpT7EbhB5DbwkT=5zNF7MO-TGyHA@mail.gmail.com>
	<54B2EB610B7F1340BB6A0D4CA04A4F10013EFF76B1@orsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: "Locktyukhin, Maxim" <maxim.locktyukhin@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43287 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab1HHGHg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Aug 2011 02:07:36 -0400
Received: by vws1 with SMTP id 1so3162309vws.19
        for <linux-crypto@vger.kernel.org>; Sun, 07 Aug 2011 23:07:36 -0700 (PDT)
In-Reply-To: <54B2EB610B7F1340BB6A0D4CA04A4F10013EFF76B1@orsmsx505.amr.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 8, 2011 at 1:48 PM, Locktyukhin, Maxim
<maxim.locktyukhin@intel.com> wrote:

> 20 (and more) cycles per byte shown below are not reasonable numbers for SHA-1
> - ~6 c/b (as can be seen in some of the results for Core2) is the expected results ...

Ten years ago, on Pentium II, one benchmark showed 13 cycles/byte for SHA-1.
http://www.freeswan.org/freeswan_trees/freeswan-2.06/doc/performance.html#perf.estimate
