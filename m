From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] Crypto: CESA: Add support for DT based instantiation.
Date: Tue, 04 Sep 2012 00:00:01 +0200
Message-ID: <50452861.6060608@gmail.com>
References: <1346696974-23443-1-git-send-email-andrew@lunn.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: devicetree-discuss@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	Jason Cooper <jason@lakedaemon.net>,
	linux ARM <linux-arm-kernel@lists.infradead.org>,
	sebastian.hesselbarth@googlemail.com
To: Andrew Lunn <andrew@lunn.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63864 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab2ICWAH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Sep 2012 18:00:07 -0400
Received: by bkwj10 with SMTP id j10so2376627bkw.19
        for <linux-crypto@vger.kernel.org>; Mon, 03 Sep 2012 15:00:05 -0700 (PDT)
In-Reply-To: <1346696974-23443-1-git-send-email-andrew@lunn.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/03/2012 08:29 PM, Andrew Lunn wrote:
> Added support for getting the interrupt number and address of SRAM
> from DT.

Tested-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

on DT-enabled Dove.
