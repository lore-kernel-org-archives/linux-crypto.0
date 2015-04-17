From: leroy christophe <christophe.leroy@c-s.fr>
Subject: Re: [PATCH v3 03/17] crypto: talitos - talitos_ptr renamed ptr for
 more lisibility
Date: Fri, 17 Apr 2015 18:25:55 +0200
Message-ID: <55313413.2050604@c-s.fr>
References: <20150417142356.797BC1A242C@localhost.localdomain> <063D6719AE5E284EB5DD2968C1650D6D1CB21235@AcuExch.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: David Laight <David.Laight@ACULAB.COM>,
	Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David S Miller <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1CB21235@AcuExch.aculab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Le 17/04/2015 17:14, David Laight a =C3=A9crit :
> From: Christophe Leroy
>> Linux CodyingStyle recommends to use short variables for local
>> variables. ptr is just good enough for those 3 lines functions.
>> It helps keep single lines shorter than 80 characters.
> ...
>> -static void to_talitos_ptr(struct talitos_ptr *talitos_ptr, dma_add=
r_t dma_addr)
>> +static void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_=
addr)
>>   {
>> -	talitos_ptr->ptr =3D cpu_to_be32(lower_32_bits(dma_addr));
>> -	talitos_ptr->eptr =3D upper_32_bits(dma_addr);
>> +	ptr->ptr =3D cpu_to_be32(lower_32_bits(dma_addr));
>> +	ptr->eptr =3D upper_32_bits(dma_addr);
>>   }
> ...
>
> Maybe, but 'ptr' isn't a good choice.
>
>
Any suggestion ?

Christophe
