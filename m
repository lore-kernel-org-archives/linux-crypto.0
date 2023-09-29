Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9176E732D0
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Sep 2023 10:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbjI2KqA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Sep 2023 06:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbjI2Kp7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Sep 2023 06:45:59 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D7DF9;
        Fri, 29 Sep 2023 03:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1695984358; x=1727520358;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1lrzESEZg7Dt9yS/MtYboY+ve0hupxWVdPmHKBJKar8=;
  b=UntMu+HQujWw63antQJkZ2zd447YveScUG1OTssQm/eb0hn1Ad04vcVq
   Au+oOAdGIlUTvjKf8KRwyeHVOK+nYefaVPOP4oBXu1atKwYD1q8NYMPZc
   qKlnynIMCbBGR+tG1kbNLlC72XyAGbcwtosePsxFCrQZNJsgBEcQUOVJ6
   A=;
X-IronPort-AV: E=Sophos;i="6.03,187,1694736000"; 
   d="scan'208";a="354037821"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-f7c754c9.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2023 10:45:55 +0000
Received: from EX19MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-f7c754c9.us-west-2.amazon.com (Postfix) with ESMTPS id 41F7940E6E;
        Fri, 29 Sep 2023 10:45:53 +0000 (UTC)
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Fri, 29 Sep 2023 10:45:40 +0000
Received: from [0.0.0.0] (10.253.83.51) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.37; Fri, 29 Sep
 2023 10:45:37 +0000
Message-ID: <d6e4fba3-ecaf-4cf3-8447-0f9a8f8bbaeb@amazon.com>
Date:   Fri, 29 Sep 2023 12:45:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] misc: Add Nitro Secure Module driver
Content-Language: en-GB
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Olivia Mackall" <olivia@selenic.com>,
        Petre Eftime <petre.eftime@gmail.com>,
        "Erdem Meydanlli" <meydanli@amazon.nl>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
References: <20230928224645.19768-1-graf@amazon.com>
 <20230928224645.19768-2-graf@amazon.com>
 <2023092918-sulfide-stonework-f6b7@gregkh>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <2023092918-sulfide-stonework-f6b7@gregkh>
X-Originating-IP: [10.253.83.51]
X-ClientProxiedBy: EX19D033UWA004.ant.amazon.com (10.13.139.85) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Ck9uIDI5LjA5LjIzIDA3OjQ1LCBHcmVnIEtyb2FoLUhhcnRtYW4gd3JvdGU6Cj4KPiBPbiBUaHUs
IFNlcCAyOCwgMjAyMyBhdCAxMDo0Njo0NFBNICswMDAwLCBBbGV4YW5kZXIgR3JhZiB3cm90ZToK
Pj4gKy8qIFJlZ2lzdGVyIHRoaXMgYXMgYSBtaXNjIGRyaXZlciAqLwo+PiArI2RlZmluZSBOU01f
REVWX05BTUUgICAgICAgICAgIm5zbSIKPj4gKyNkZWZpbmUgTlNNX0lPQ1RMX01BR0lDICAgICAg
IDB4MEEKPj4gKyNkZWZpbmUgTlNNX0lPX1JFUVVFU1QgICAgICAgIF9JT1dSKE5TTV9JT0NUTF9N
QUdJQywgMCwgc3RydWN0IG5zbV9tZXNzYWdlKQo+IFlvdSBoYXZlIGFuIGlvY3RsIGZvciB0aGlz
IGRyaXZlciwgeWV0IG5vIGluY2x1ZGUvdWFwaS8gZmlsZSBmb3IgaXQ/Cj4gSG93IGlzIHVzZXJz
cGFjZSBzdXBwb3NlZCB0byBrbm93IGFib3V0IHRoaXMgYW5kIHVzZSBpdD8KCgpEJ29oLiBXaWxs
IGZpeCA6KS4gVGhhbmtzIQoKCkFsZXgKCgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdl
cm1hbnkgR21iSApLcmF1c2Vuc3RyLiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5n
OiBDaHJpc3RpYW4gU2NobGFlZ2VyLCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRz
Z2VyaWNodCBDaGFybG90dGVuYnVyZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVz
dC1JRDogREUgMjg5IDIzNyA4NzkKCgo=

