From: Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>
Subject: Re: [PATCH 01/19] User-space API definition
Date: Sat, 21 Aug 2010 09:35:44 +0200
Message-ID: <AANLkTikM44mbBdYt1EWgXJYEFqY4F0_umG74-6eL2xW=@mail.gmail.com>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
	<1282293963-27807-2-git-send-email-mitr@redhat.com>
	<4C6E79B2.1040309@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?Q?Miloslav_Trma=C4=8D?= <mitr@redhat.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	linux-crypto@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
	linux-kernel@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42194 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab0HUHfp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 21 Aug 2010 03:35:45 -0400
In-Reply-To: <4C6E79B2.1040309@s5r6.in-berlin.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

2010/8/20 Stefan Richter <stefanr@s5r6.in-berlin.de>:

>> +struct ncr_session_input_data {
>> + =C2=A0 =C2=A0 const void __user *data;
>> + =C2=A0 =C2=A0 __kernel_size_t data_size;
>> +};
>> +
>> +};
> Why not using fixed-size fit-all members?
> struct ncr_session_input_data {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0__u64 data; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 /* user pointer, cast to/from u64 */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0__u32 data_size; =C2=A0 =C2=A0 =C2=A0 =C2=A0=
/* or __u64? */
> };

A reason is that using (void*) is cleaner as an API. It avoids the
pointer to int casting and the warnings that such a cast will have.

regards,
Nikos
