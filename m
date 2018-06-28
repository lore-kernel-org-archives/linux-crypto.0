From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] crypto: ccree: fix finup
Date: Thu, 28 Jun 2018 10:06:19 +0300
Message-ID: <CAOtvUMeO3XuFUZvauc_z+bkSqnO9bJdK77oeDJ4CpTVSAiK3wg@mail.gmail.com>
References: <1529581652-31294-1-git-send-email-hadar.gat@arm.com> <CAOtvUMc0j+5+uYZH9=kwV=Ptx_df=qSRceGsuouf-FuV7Mkw0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Ofir Drang <ofir.drang@arm.com>,
        Gilad Ben-Yossef <gilad.BenYossef@arm.com>,
        stable@vger.kernel.org
To: Hadar Gat <hadar.gat@arm.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAOtvUMc0j+5+uYZH9=kwV=Ptx_df=qSRceGsuouf-FuV7Mkw0w@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,


On Thu, Jun 21, 2018 at 3:25 PM, Gilad Ben-Yossef <gilad@benyossef.com> wro=
te:
> On Thu, Jun 21, 2018 at 2:47 PM, Hadar Gat <hadar.gat@arm.com> wrote:
>> finup() operation was incorrect, padding was missing.
>> Fix by setting the ccree HW to enable padding.
>>
>> Signed-off-by: Hadar Gat <hadar.gat@arm.com>
>> Cc: stable@vger.kernel.org
>
> Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>
>
> Gilad
>

I took a 2nd look at this with Hadar and we realized we can write this
in a way that allows
for more code sharing. Please drop this patch. I'll be sending a revised ve=
rsion
in a second.

Thanks!
Gilad



--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
