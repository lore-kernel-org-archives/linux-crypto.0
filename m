From: Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH v2 2/2] crypto, x86: SSSE3 based SHA1 implementation for x86-64
Date: Thu, 4 Aug 2011 19:08:07 +0200
Message-ID: <CA+rthh_5sd1qgvYjLTR69RY-rJVC2ukzDHG1sVPwNctnpnxhiA@mail.gmail.com>
References: <1311529994-7924-1-git-send-email-minipli@googlemail.com>
	<1311529994-7924-3-git-send-email-minipli@googlemail.com>
	<20110804064436.GA16247@gondor.apana.org.au>
	<CA+rthh_nx2bvM71M=AdUuhEpT7EbhB5DbwkT=5zNF7MO-TGyHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Maxim Locktyukhin <maxim.locktyukhin@intel.com>,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58857 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab1HDRII (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Aug 2011 13:08:08 -0400
In-Reply-To: <CA+rthh_nx2bvM71M=AdUuhEpT7EbhB5DbwkT=5zNF7MO-TGyHA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 4, 2011 at 7:05 PM, Mathias Krause <minipli@googlemail.com> wrote:
> It does. Just have a look at how fpu_available() is implemented:

read: irq_fpu_usable()
