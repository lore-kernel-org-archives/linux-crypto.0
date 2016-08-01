From: Nicolas Brunie <nbrunie@kalray.eu>
Subject: Re: a few questions on AF_ALG specification (AEAD,
 socket/connection, ...)
Date: Mon, 1 Aug 2016 11:14:07 +0200 (CEST)
Message-ID: <706562074.101482886.1470042847657.JavaMail.zimbra@kalray.eu>
References: <57974E05.3030502@kalray.eu> <2101527.nPISZxk4jO@tauon.atsec.com> <429e56bc-4ae9-a682-63a4-b34a38295abc@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Stephan Mueller <smueller@chronox.de>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra1.kalray.eu ([92.103.151.219]:42206 "EHLO
	zimbra1.kalray.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbcHAJYl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Aug 2016 05:24:41 -0400
In-Reply-To: <429e56bc-4ae9-a682-63a4-b34a38295abc@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
  In my understanding, a socket is the file descriptor given as argument to a bind call and a connection is the file descriptor returned by an accept call. 

NB



----- Mail original -----
De: "Tadeusz Struk" <tadeusz.struk@intel.com>
À: "Stephan Mueller" <smueller@chronox.de>, "Nicolas Brunie" <nicolas.brunie@kalray.eu>
Cc: "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>
Envoyé: Mardi 26 Juillet 2016 16:37:51
Objet: Re: a few questions on AF_ALG specification (AEAD, socket/connection, ...)

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
