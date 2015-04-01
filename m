From: Corentin LABBE <clabbe.montjoie@gmail.com>
Subject: Re: [linux-sunxi] Re: AW: problem with testing a CTR block cipher
 mode which is partially working
Date: Wed, 01 Apr 2015 13:16:27 +0200
Message-ID: <551BD38B.6050307@gmail.com>
References: <55198F14.1090902@gmail.com>, 	<12EF8D94C6F8734FB2FF37B9FBEDD1735FC8AB40@EXCHANGE.collogia.de>, 	<551AE140.3000209@gmail.com> <2015040110063394945846@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: linux-sunxi@googlegroups.com,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:38311 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbbDALSi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 1 Apr 2015 07:18:38 -0400
Received: by wibgn9 with SMTP id gn9so62020688wib.1
        for <linux-crypto@vger.kernel.org>; Wed, 01 Apr 2015 04:18:36 -0700 (PDT)
In-Reply-To: <2015040110063394945846@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04/01/15 04:06, kevin.z.m.zh@gmail.com wrote:
> Dear All,
> 
> 
> About the SS module, there is some detail information.
> There is some issues on the SS hardware module, the issues make the some
> AES/DES/3DS algorithm be not available.
> 1. The byte order of the counter is wrong, make the result error, so, the CTR
> mode is not available.
> 2. Hardware don't support the continuous subcontracting, make the CTS mode is
> not available.
> 3. Another issue need be taken attention is that hardware will modify the key
> register when do AES encrypt, so, it need software to restore the key register
> 
> when doing every frame.
> 
> These issues are presented on the A10, A13, A20, A31 and A33.
> The issues of SS module have been fixed on the A83T platform, so, I suggest to
> take more attention to the A83T platform if any interest in the SS module.
> 
> If any problem, please don't hesitate to contact me(kevin@allwinnertech.com)
> 
> or Shuge(shuge@allwinnertech.com).
> 

Thanks for your answer, I have loose hours on that problem.

Perhaps you could update all datasheet/user manual about this known issue ?

Regards
