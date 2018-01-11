From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: Getting the ccree driver out of staging
Date: Thu, 11 Jan 2018 11:42:16 +0300
Message-ID: <20180111084216.oq7pnj6iwgatdld2@mwanda>
References: <CAOtvUMdo_ZJ-M-=apA1a=70KyVBX2J0pEVc+Uc9i=rYWCie6Hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Ofir Drang <Ofir.Drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <CAOtvUMdo_ZJ-M-=apA1a=70KyVBX2J0pEVc+Uc9i=rYWCie6Hw@mail.gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Here are my remaining Smatch warnings:

    drivers/staging/ccree/cc_driver.c:219 init_cc_resources()
    error: '%pa' can only be followed by one of [dp]

drivers/staging/ccree/cc_driver.c
   217  
   218          if (rc) {
   219                  dev_err(dev, "Failed in dma_set_mask, mask=%par\n",
                                                                      ^
This 'r' is is treated as a 'p'.  Not sure what was intended.

   220                          &dma_mask);
   221                  return rc;
   222          }
   223  


    drivers/staging/ccree/cc_buffer_mgr.c:1067 cc_aead_chain_data()
    warn: inconsistent indenting

drivers/staging/ccree/cc_buffer_mgr.c
  1064          if (src_mapped_nents > LLI_MAX_NUM_OF_DATA_ENTRIES) {
  1065                  dev_err(dev, "Too many fragments. current %d max %d\n",
  1066                          src_mapped_nents, LLI_MAX_NUM_OF_DATA_ENTRIES);
  1067                          return -ENOMEM;
                                ^^^^^^^^^^^^^^
  1068          }

    drivers/staging/ccree/cc_cipher.c:373 cc_cipher_setkey()
    warn: inconsistent indenting

drivers/staging/ccree/cc_cipher.c
   369          dma_sync_single_for_device(dev, ctx_p->user.key_dma_addr,
   370                                     max_key_buf_size, DMA_TO_DEVICE);
   371          ctx_p->keylen = keylen;
   372  
   373           dev_dbg(dev, "return safely");
                ^
One extra space.

   374          return 0;
   375  }

regards,
dan carpenter
