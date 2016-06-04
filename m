From: Gadre Nayan <gadrenayan@gmail.com>
Subject: Re: Unable to decrypt message
Date: Sat, 4 Jun 2016 16:07:58 +0530
Message-ID: <CAKJ7aR7a-HhCtXvW7e3jCuE7NSv0OBRpTqC+t-GqG8X6__KGzA@mail.gmail.com>
References: <CAKJ7aR4cxqoDQXvcULgwrQyok7fbi_Cq4jTL8x=WZwd03YEbCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:35240 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbcFDKiB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 4 Jun 2016 06:38:01 -0400
Received: by mail-io0-f179.google.com with SMTP id o189so92986207ioe.2
        for <linux-crypto@vger.kernel.org>; Sat, 04 Jun 2016 03:38:00 -0700 (PDT)
In-Reply-To: <CAKJ7aR4cxqoDQXvcULgwrQyok7fbi_Cq4jTL8x=WZwd03YEbCg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Additional information: My Key length is 32 bytes and iv length is 16
bytes but randomly generated. Data length is 20 bytes.
AFAIK IV data would be used in the 1st iteration of cbc mode (since
its chaining). So any Initialization vector  should have worked. But
it doesn't. How ?



On Sat, Jun 4, 2016 at 3:51 PM, Gadre Nayan <gadrenayan@gmail.com> wrote:
> Hi,
>
> I am trying to encrypt decrypt data over the wire. On the receiver
> side I have a pre-routing hook where I get reference to my encrypted
> data and apply decryption using the skcipher api's, however I am
> unable to get the same data back.
>
> My algo is same on both ends "cbc(aes)" and using CRYPTO_ALG_ASYNC ,
> key is also same (content and size).
>
> Should the Initialization vector also be the same. Since I am
> generating iv random bytes on both ends.
>
> Thanks
