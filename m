From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] crypto: ccree: fix finup
Date: Thu, 21 Jun 2018 15:25:50 +0300
Message-ID: <CAOtvUMc0j+5+uYZH9=kwV=Ptx_df=qSRceGsuouf-FuV7Mkw0w@mail.gmail.com>
References: <1529581652-31294-1-git-send-email-hadar.gat@arm.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1529581652-31294-1-git-send-email-hadar.gat@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jun 21, 2018 at 2:47 PM, Hadar Gat <hadar.gat@arm.com> wrote:
> finup() operation was incorrect, padding was missing.
> Fix by setting the ccree HW to enable padding.
>
> Signed-off-by: Hadar Gat <hadar.gat@arm.com>
> Cc: stable@vger.kernel.org

Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

Gilad


--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
