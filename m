From: Jan Stancek <jstancek@redhat.com>
Subject: Re: [bug] crypto/vmx/p8_ghash memory corruption in 4.8-rc7
Date: Mon, 26 Sep 2016 13:50:04 -0400 (EDT)
Message-ID: <978710766.77328.1474912204420.JavaMail.zimbra@redhat.com>
References: <450861381.1559123.1474673197124.JavaMail.zimbra@redhat.com> <1655600242.1561022.1474676547316.JavaMail.zimbra@redhat.com> <20160926141510.GC5031@gallifrey>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: rui y wang <rui.y.wang@intel.com>, herbert@gondor.apana.org.au,
        mhcerri@linux.vnet.ibm.com, leosilva@linux.vnet.ibm.com,
        pfsmorigo@linux.vnet.ibm.com, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
To: Marcelo Cerri <marcelo.cerri@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160926141510.GC5031@gallifrey>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org




----- Original Message -----
> From: "Marcelo Cerri" <marcelo.cerri@canonical.com>
> To: "Jan Stancek" <jstancek@redhat.com>
> Cc: "rui y wang" <rui.y.wang@intel.com>, herbert@gondor.apana.org.au, mhcerri@linux.vnet.ibm.com,
> leosilva@linux.vnet.ibm.com, pfsmorigo@linux.vnet.ibm.com, linux-crypto@vger.kernel.org,
> linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
> Sent: Monday, 26 September, 2016 4:15:10 PM
> Subject: Re: [bug] crypto/vmx/p8_ghash memory corruption in 4.8-rc7
> 
> Hi Jan,
> 
> Just out of curiosity, have you tried to use "76" on both values to
> check if the problem still happens?

I did, I haven't seen any panics with such patch:

@@ -211,7 +212,7 @@ struct shash_alg p8_ghash_alg = {
        .update = p8_ghash_update,
        .final = p8_ghash_final,
        .setkey = p8_ghash_setkey,
-       .descsize = sizeof(struct p8_ghash_desc_ctx),
+       .descsize = sizeof(struct p8_ghash_desc_ctx) + 20,
        .base = {
                 .cra_name = "ghash",
                 .cra_driver_name = "p8_ghash",
