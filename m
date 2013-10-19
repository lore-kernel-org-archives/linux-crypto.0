From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] crypto: n2_core: insert '!err' condition in else scope
Date: Sat, 19 Oct 2013 18:49:19 -0400 (EDT)
Message-ID: <20131019.184919.1292439830365652584.davem@davemloft.net>
References: <1382188171-25595-1-git-send-email-geyslan@gmail.com>
	<20131019.183825.2015665991258674429.davem@davemloft.net>
	<CAGG-pUSMJTbGHEhCOy0PRLNN4+jyVB8oB3mca1O9sb2YbpQ-fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kernel-br@googlegroups.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: geyslan@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGG-pUSMJTbGHEhCOy0PRLNN4+jyVB8oB3mca1O9sb2YbpQ-fg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

=46rom: Geyslan Greg=F3rio Bem <geyslan@gmail.com>
Date: Sat, 19 Oct 2013 19:42:35 -0300

> 2013/10/19 David Miller <davem@davemloft.net>:
>> From: "Geyslan G. Bem" <geyslan@gmail.com>
>> Date: Sat, 19 Oct 2013 10:09:31 -0300
>>
>>> This patch moves the '!err' condition into the above else scope,
>>> what is more obvious and has the secondary goal of avoid false-posi=
tives
>>> in statical analyze tools.
>>>
>>> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
>>
>> I do not think patches should be applied to satisfy tools if the
>> code is semantically correct.
>=20
> Yes, Miller, I agree. But as I mentioned:
> ".. and has as the 'secondary' goal of avoid false-positives in
> statical analyze tools."
>=20
> The 'primary' goal is to not repeat a condition test:
> "This patch moves the '!err' condition into the above else scope, wha=
t
> is more obvious ..."

I still do not feel that this change is a net-positive.  Sorry.
