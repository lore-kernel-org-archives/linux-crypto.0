From: Lee Nipper <lee.nipper@gmail.com>
Subject: Re: [PATCH][RFC] crypto: talitos - add hmac algorithms
Date: Wed, 28 Apr 2010 16:44:08 -0500
Message-ID: <x2oeabe9a7b1004281444pdd22136am212e75ed06df72a3@mail.gmail.com>
References: <4bd82b35.064c640a.62c0.4de1@mx.google.com>
Reply-To: lee.nipper@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:60428 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab0D1VoM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Apr 2010 17:44:12 -0400
Received: by qyk9 with SMTP id 9so21937449qyk.1
        for <linux-crypto@vger.kernel.org>; Wed, 28 Apr 2010 14:44:09 -0700 (PDT)
In-Reply-To: <4bd82b35.064c640a.62c0.4de1@mx.google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 28, 2010 at 07:33,  <lee.nipper@gmail.com> wrote:
> Add the these hmac algorithms to talitos:
> =A0 =A0hmac(md5),
> =A0 =A0hmac(sha1),
> =A0 =A0hmac(sha256),
> =A0 =A0hmac(sha384),
> =A0 =A0hmac(sha512).
> These are all type ahash.
>

This patch jumped in front of the 3rd patch in the series of 3 in the
message order.
The hmac patch should be applied _after_ the 3 patches in the series fo=
r ahash.
I wanted to clarify that for the record.

Thanks.

-Lee
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
