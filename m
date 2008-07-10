From: Arturas K <arturas@cerberis.soften.ktu.lt>
Subject: Ideas about Linux CryptoAPI userspace interface
Date: Thu, 10 Jul 2008 11:56:20 +0300
Message-ID: <4875CEB4.0@cerberis.soften.ktu.lt>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cerberis.soften.ktu.lt ([193.219.33.193]:44152 "EHLO
	cerberis.soften.ktu.lt" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbYGJJSX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jul 2008 05:18:23 -0400
Received: from [172.16.6.49] (unknown [193.219.160.108])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by cerberis.soften.ktu.lt (Postfix) with ESMTP id 326B516000463
	for <linux-crypto@vger.kernel.org>; Thu, 10 Jul 2008 11:57:42 +0300 (EEST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I run trough mailing list archives back to "ancient times" and from time 
to time there is a noise about the lack of cryptoapi userspace 
interface. There were just wining ( like me :D ), there were some 
attempts to do something reasonable/usable - but nothing reached 
mainline kernel...

I am not good at C or C++, so I will limit my contribution to some 
observations/ideas:

* in user space, openssl is the defacto cryptography provider. it even 
supports some hardware accelerators.

* the biggest desire for cryptoapi userspace interface comes from corner 
cases there kernel supports hardware acceleration, while openssl does 
not (like geode aes engine).

* for this interface to achieve reasonable adoption (succeed),
it must be exposed to openssl (aka some sort of openssl engine)

* there were attempts to port cryptodev, but filed due some gurus don't 
like the interface or the implementation or both.

* despite cryptodev is far from ideal interface - it already has support 
in openssl.

* unless there are willing ones to code on both (kernel and openssl), 
why not to properly implement cryptodev, mark it as highly experimental 
and add a fat warning what it will be tiered apart once someone comes 
with something better?

* I beleve, there will be more willing ones to create proper interface 
once there is actual user base instead of targeted one :)

---
teaser: I dream about cheap stock vga card acting as cryptography 
accelerator to feed 10G ethernet links at no cost :D
---
ArturasK.
