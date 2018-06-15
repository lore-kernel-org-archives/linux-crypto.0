From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: arm64/aes-blk - fix and move
 skcipher_walk_done out of kernel_neon_begin,_end
Date: Fri, 15 Jun 2018 23:14:03 +0800
Message-ID: <20180615151403.cdvalbmdrt7gnodk@gondor.apana.org.au>
References: <1528443704-26850-1-git-send-email-hejianet@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: ard.biesheuvel@linaro.org, catalin.marinas@arm.com, will.deacon@arm.com,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, jia.he@hxt-semitech.com,
 linux-crypto@vger.kernel.org, hejianet@gmail.com, davem@davemloft.net,
 linux-arm-kernel@lists.infradead.org
To: Jia He <hejianet@gmail.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1528443704-26850-1-git-send-email-hejianet@gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Jia He <hejianet@gmail.com> wrote:
> In a arm64 server(QDF2400),I met a similar might-sleep warning as [1]:
> [    7.019116] BUG: sleeping function called from invalid context at
> ./include/crypto/algapi.h:416
> [    7.027863] in_atomic(): 1, irqs_disabled(): 0, pid: 410, name:
> cryptomgr_test
> [    7.035106] 1 lock held by cryptomgr_test/410:
> [    7.039549]  #0:         (ptrval) (&drbg->drbg_mutex){+.+.}, at:
> drbg_instantiate+0x34/0x398
> [    7.048038] CPU: 9 PID: 410 Comm: cryptomgr_test Not tainted
> 4.17.0-rc6+ #27
> [    7.068228]  dump_backtrace+0x0/0x1c0
> [    7.071890]  show_stack+0x24/0x30
> [    7.075208]  dump_stack+0xb0/0xec
> [    7.078523]  ___might_sleep+0x160/0x238
> [    7.082360]  skcipher_walk_done+0x118/0x2c8
> [    7.086545]  ctr_encrypt+0x98/0x130
> [    7.090035]  simd_skcipher_encrypt+0x68/0xc0
> [    7.094304]  drbg_kcapi_sym_ctr+0xd4/0x1f8
> [    7.098400]  drbg_ctr_update+0x98/0x330
> [    7.102236]  drbg_seed+0x1b8/0x2f0
> [    7.105637]  drbg_instantiate+0x2ac/0x398
> [    7.109646]  drbg_kcapi_seed+0xbc/0x188
> [    7.113482]  crypto_rng_reset+0x4c/0xb0
> [    7.117319]  alg_test_drbg+0xec/0x330
> [    7.120981]  alg_test.part.6+0x1c8/0x3c8
> [    7.124903]  alg_test+0x58/0xa0
> [    7.128044]  cryptomgr_test+0x50/0x58
> [    7.131708]  kthread+0x134/0x138
> [    7.134936]  ret_from_fork+0x10/0x1c
> 
> Seems there is a bug in Ard Biesheuvel's commit.
> Fixes: 683381747270 ("crypto: arm64/aes-blk - move kernel mode neon
> en/disable into loop")
> 
> [1] https://www.spinics.net/lists/linux-crypto/msg33103.html
> 
> Signed-off-by: jia.he@hxt-semitech.com
> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: <stable@vger.kernel.org> # 4.17

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
