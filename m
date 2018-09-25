From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: linux-next: Tree for Sep 25 (crypto/caam/)
Date: Tue, 25 Sep 2018 08:38:33 -0700
Message-ID: <f1436714-629e-a6ee-9fbc-525914652064@infradead.org>
References: <20180925153937.07660ca8@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180925153937.07660ca8@canb.auug.org.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 9/24/18 10:39 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20180924:
> 

on i386:
# CONFIG_NET is not set


drivers/crypto/caam/caamalg_qi2.o: In function `dpaa2_caam_fqdan_cb':
caamalg_qi2.c:(.text+0x502): undefined reference to `napi_schedule_prep'
caamalg_qi2.c:(.text+0x50d): undefined reference to `__napi_schedule_irqoff'
drivers/crypto/caam/caamalg_qi2.o: In function `dpaa2_dpseci_poll':
caamalg_qi2.c:(.text+0x9ee): undefined reference to `napi_complete_done'
drivers/crypto/caam/caamalg_qi2.o: In function `dpaa2_caam_probe':
caamalg_qi2.c:(.text+0x68f1): undefined reference to `netif_napi_add'
drivers/crypto/caam/caamalg_qi2.o: In function `dpaa2_caam_remove':
caamalg_qi2.c:(.text.unlikely+0x1ec): undefined reference to `napi_disable'
caamalg_qi2.c:(.text.unlikely+0x1f3): undefined reference to `netif_napi_del'


-- 
~Randy
