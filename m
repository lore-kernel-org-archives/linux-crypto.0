From: Bai Shuwei <baishuwei@gmail.com>
Subject: Re: how the key is generated?
Date: Wed, 27 Jan 2010 11:21:12 +0800
Message-ID: <f3566d61001261921v2a7f319bgddb3a3bc971eea10@mail.gmail.com>
References: <f3566d61001260041s13286706ra5c032ea2b4ce1d6@mail.gmail.com>
	 <4B5EAEB0.9040205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:48590 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab0A0DVM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2010 22:21:12 -0500
Received: by pxi12 with SMTP id 12so4048340pxi.33
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jan 2010 19:21:12 -0800 (PST)
In-Reply-To: <4B5EAEB0.9040205@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 26, 2010 at 4:58 PM, Milan Broz <mbroz@redhat.com> wrote:
> On 01/26/2010 09:41 AM, Bai Shuwei wrote:
>> Hello, everyone:
>> =A0 =A0 i add one line in the setkey function which is in xts.c file=
 to
>> print the in_key value. I find the key value not same i set in the
>> keyfile by cryptsetup
>>
>> =A0 =A0my command is
>> # =A0 cryptsetup luksFormat -d my_keyfile -c xts-aes-plain -s 256 /d=
ev/loop0
>
> -d is key file for key slot (passphrase), volume (master) key for enc=
ryption
> is generated using RNG during luksFormat inside cryptsetup.
>
> You can use pre-generated master key using --master-key-file in crypt=
setup 1.1.x
> (but note it reads raw input, not hexa encoding). See man page.
>
> You do not need to modify xts.c btw, try "dmsetup table --showkeys" f=
or active
> dm-crypt mappings to show used volume key.
>
> (and also better use dm-crypt@saout.de mailing list for questions rel=
ated to
> userspace cryptsetup)
>
> Milan
> --
> mbroz@redhat.com
>

Hi, thanks Milan firstly!
I use "dmsetup table --showkeys" get the bellow information.

disk$ sudo dmsetup table --showkeys /dev/mapper/dsi0
0 2040 crypt aes-xts-plain
3131313131313131313131313131313131313131313131313131313131313131 0 7:0
2056

If i forget the passphase, can i use the above information/key to
recovery my disk?

Best Regards

Bai Shuwei


--=20
Love other people, as same as love yourself!
Don't think all the time, do it by your hands!

E-Mail: baishuwei@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
