From: Gadre Nayan <gadrenayan@gmail.com>
Subject: Unable to decrypt message
Date: Sat, 4 Jun 2016 15:51:47 +0530
Message-ID: <CAKJ7aR4cxqoDQXvcULgwrQyok7fbi_Cq4jTL8x=WZwd03YEbCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:34849 "EHLO
	mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbcFDK2D (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 4 Jun 2016 06:28:03 -0400
Received: by mail-it0-f65.google.com with SMTP id z123so1247771itg.2
        for <linux-crypto@vger.kernel.org>; Sat, 04 Jun 2016 03:28:02 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I am trying to encrypt decrypt data over the wire. On the receiver
side I have a pre-routing hook where I get reference to my encrypted
data and apply decryption using the skcipher api's, however I am
unable to get the same data back.

My algo is same on both ends "cbc(aes)" and using CRYPTO_ALG_ASYNC ,
key is also same (content and size).

Should the Initialization vector also be the same. Since I am
generating iv random bytes on both ends.

Thanks
