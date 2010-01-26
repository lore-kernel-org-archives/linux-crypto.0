From: Milan Broz <mbroz@redhat.com>
Subject: Re: how the key is generated?
Date: Tue, 26 Jan 2010 09:58:24 +0100
Message-ID: <4B5EAEB0.9040205@redhat.com>
References: <f3566d61001260041s13286706ra5c032ea2b4ce1d6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Bai Shuwei <baishuwei@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050Ab0AZI61 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2010 03:58:27 -0500
In-Reply-To: <f3566d61001260041s13286706ra5c032ea2b4ce1d6@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/26/2010 09:41 AM, Bai Shuwei wrote:
> Hello, everyone:
>     i add one line in the setkey function which is in xts.c file to
> print the in_key value. I find the key value not same i set in the
> keyfile by cryptsetup
> 
>    my command is
> #   cryptsetup luksFormat -d my_keyfile -c xts-aes-plain -s 256 /dev/loop0

-d is key file for key slot (passphrase), volume (master) key for encryption
is generated using RNG during luksFormat inside cryptsetup.

You can use pre-generated master key using --master-key-file in cryptsetup 1.1.x
(but note it reads raw input, not hexa encoding). See man page.

You do not need to modify xts.c btw, try "dmsetup table --showkeys" for active
dm-crypt mappings to show used volume key.

(and also better use dm-crypt@saout.de mailing list for questions related to
userspace cryptsetup)

Milan
--
mbroz@redhat.com
