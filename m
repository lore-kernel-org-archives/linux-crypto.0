From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: a few questions on AF_ALG specification (AEAD, socket/connection,
 ...)
Date: Tue, 26 Jul 2016 07:37:51 -0700
Message-ID: <429e56bc-4ae9-a682-63a4-b34a38295abc@intel.com>
References: <57974E05.3030502@kalray.eu> <2101527.nPISZxk4jO@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>,
	Nicolas Brunie <nicolas.brunie@kalray.eu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:45409 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbcGZOiJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jul 2016 10:38:09 -0400
In-Reply-To: <2101527.nPISZxk4jO@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
On 07/26/2016 04:54 AM, Stephan Mueller wrote:
>> > Is it true that the key (defined via setsockopt) is common to all the
>> > connections but the IV (defined through message control header) is
>> > specific to each connection ?
> Yes.

I think that's not correct. Please define a "connection".
If you think of connections as separate sockets, then you can
have different keys for each socket. The difference is that
you set a key per each socket once, and you send IV for each
operation (encrypt/decrypt).
Thanks,
-- 
TS
