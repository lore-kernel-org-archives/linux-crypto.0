From: "Stephen  Bates" <sbates@raithlin.com>
Subject: Re: [PATCH 4/7] alpha: provide ioread64 and iowrite64 implementations
Date: Thu, 22 Jun 2017 17:29:28 +0000
Message-ID: <E70FB7EB-3A05-4A08-A85E-020F47751E3B@raithlin.com>
References: <20170622164817.25515-1-logang@deltatee.com>
 <20170622164817.25515-5-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Richard Henderson <rth@twiddle.net>,
        "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
To: Logan Gunthorpe <logang@deltatee.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-ntb@googlegroups.com" <linux-ntb@googlegroups.com>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-eopbgr660109.outbound.protection.outlook.com ([40.107.66.109]:44213
        "EHLO CAN01-QB1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751835AbdFVR3b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2017 13:29:31 -0400
In-Reply-To: <20170622164817.25515-5-logang@deltatee.com>
Content-Language: en-US
Content-ID: <5D9297D421B415469B6810A66E426463@CANPRD01.PROD.OUTLOOK.COM>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

PiArI2RlZmluZSBpb3dyaXRlNjRiZSh2LHApIGlvd3JpdGUzMihjcHVfdG9fYmU2NCh2KSwgKHAp
KQ0KIA0KTG9nYW4sIHRoYW5rcyBmb3IgdGFraW5nIHRoaXMgY2xlYW51cCBvbi4gSSB0aGluayB0
aGlzIHNob3VsZCBiZSBpb3dyaXRlNjQgbm90IGlvd3JpdGUzMj8NCg0KU3RlcGhlbg0KDQoNCg==
