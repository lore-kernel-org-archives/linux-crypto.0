From: Varsha Rao <rvarsha016@gmail.com>
Subject: Re: [PATCH] crypto: cavium: zip: Remove unnecessary parentheses
Date: Thu, 29 Mar 2018 21:03:45 +0530
Message-ID: <CAAFX7JTfWdaGra+kWBJt-GXVVO601K03qWnExFKFD_9vxS-03g@mail.gmail.com>
References: <20180328175736.17360-1-rvarsha016@gmail.com> <1522260676.12357.121.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        cocci <cocci@systeme.lip6.fr>
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522260676.12357.121.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Mar 28, 2018 at 11:41 PM, Joe Perches wrote:
>
> On Wed, 2018-03-28 at 23:27, Varsha Rao wrote:
> > This patch fixes the clang warning of extraneous parentheses, with the
> > following coccinelle script.
> >
> > @@
> > identifier i;
> > constant c;
> > @@
> > (
> > -((i == c))
> > +i == c
> > >
> >
> > -((i <= c))
> > +i <= c
>
> Why just the "==" and "<=" cases?
> Why not "<", ">" and ">=" too?
>
> Why not expression instead of constant?

Initially I had the other cases too and used expression instead of
constant. But the results included only "==" and "<=" cases with
constant. Along with one false positive case.

--- a/drivers/crypto/cavium/zip/zip_main.c
+++ b/drivers/crypto/cavium/zip/zip_main.c
@@ -99,7 +99,7 @@ static struct zip_device *zip_alloc_devi
  */
 struct zip_device *zip_get_device(int node)
 {
-    if ((node < MAX_ZIP_DEVICES) && (node >= 0))
+    if (node < MAX_ZIP_DEVICES && node >= 0)
         return zip_dev[node];

     zip_err("ZIP device not found for node id %d\n", node);

I checked if there was any case of extra parentheses around relational
operators left, but there were none. Hence, in the script I included
only the cases present in the result.

Thanks,
Varsha
