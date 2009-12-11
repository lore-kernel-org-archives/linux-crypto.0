From: Dimitrios Siganos <dimitris@siganos.org>
Subject: CRYPTO_TFM_REQ_MASK and CRYPTO_TFM_RES_MASK
Date: Fri, 11 Dec 2009 15:05:47 +0000
Message-ID: <4B225FCB.5050606@siganos.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lvps94-136-60-187.vps.webfusion.co.uk ([94.136.60.187]:55772
	"EHLO siganos.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbZLKPMY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Dec 2009 10:12:24 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Could someone explain what the masks CRYPTO_TFM_REQ_MASK and 
CRYPTO_TFM_RES_MASK do and why they must be manipulated before and after 
crypto_cipher_setkey(...)?

Here is an example use (from crypto_pcbc_setkey):
    crypto_cipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
    crypto_cipher_set_flags(child, crypto_tfm_get_flags(parent) &
                CRYPTO_TFM_REQ_MASK);
    err = crypto_cipher_setkey(child, key, keylen);
    crypto_tfm_set_flags(parent, crypto_cipher_get_flags(child) &
                 CRYPTO_TFM_RES_MASK);

It would be very useful if someone added some comments to these 
definitions (found in linux/crypto.h):

/*
 * Transform masks and values (for crt_flags).
 */
#define CRYPTO_TFM_REQ_MASK        0x000fff00
#define CRYPTO_TFM_RES_MASK        0xfff00000

#define CRYPTO_TFM_REQ_WEAK_KEY        0x00000100
#define CRYPTO_TFM_REQ_MAY_SLEEP    0x00000200
#define CRYPTO_TFM_REQ_MAY_BACKLOG    0x00000400
#define CRYPTO_TFM_RES_WEAK_KEY        0x00100000
#define CRYPTO_TFM_RES_BAD_KEY_LEN       0x00200000
#define CRYPTO_TFM_RES_BAD_KEY_SCHED     0x00400000
#define CRYPTO_TFM_RES_BAD_BLOCK_LEN     0x00800000
#define CRYPTO_TFM_RES_BAD_FLAGS     0x01000000

Thanks,
Dimitris
