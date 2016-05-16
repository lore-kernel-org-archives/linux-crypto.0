From: Catalin Vasile <cata.vasile@nxp.com>
Subject: Re: Decrypting data in RX path
Date: Mon, 16 May 2016 12:04:19 +0000
Message-ID: <HE1PR04MB1306ADC0ADE1CB57D2AB4A7CEE770@HE1PR04MB1306.eurprd04.prod.outlook.com>
References: <CAKJ7aR5v5LmgZ5XAv8+9mAtksdSu=LJz=oK9AmHO2t4bDiqSzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: Gadre Nayan <gadrenayan@gmail.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db3on0093.outbound.protection.outlook.com ([157.55.234.93]:44576
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750726AbcEPMTA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 May 2016 08:19:00 -0400
In-Reply-To: <CAKJ7aR5v5LmgZ5XAv8+9mAtksdSu=LJz=oK9AmHO2t4bDiqSzw@mail.gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Inline comments.

________________________________________
From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.org> on behalf of Gadre Nayan <gadrenayan@gmail.com>
Sent: Monday, May 16, 2016 2:54 PM
To: linux-crypto@vger.kernel.org
Subject: Decrypting data in RX path

Hi,

I am able to encrypt data using the asynchronous kernel crypto API's.
I can observe the encrypted data on the protocol analyzer.

I wanted to decry-pt the data now on the receiver side, So I have
following questions.

1. What is the best place to decrypt the data, in kernel space (module
(pre-routing hook) or driver) OR user space using (maybe using raw
sockets or after socket recv).

What precautions should be taken in terms of locking while using
crypto api's in kernel space in RX path (Softirq context) --> Can
someone point to existing sample in kernel where decryption is done in
RX path.
[Catalin Vasile] Look into net/ipv6/esp6.c. It's related to IPsec.

2. If I encrypt data in kernel space can I decrypt it in User-space
using same encryption methods and Keys.
[Catalin Vasile] What do you mean by "using same encryption methods" ?

Thanks.
