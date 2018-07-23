From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [REPORT] Possible unnecessary usages of GFP_ATOMIC in
 crypto/ablkcipher.c
Date: Mon, 23 Jul 2018 10:39:40 +0800
Message-ID: <78a7d726-f2fa-3afb-3451-bbd51a41a48a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

My tool DCNS reports three unnecessary usages of GFP_ATOMIC in 
crypto/ablkcipher.c:
crypto/ablkcipher.c, 162: kmalloc(GFP_ATOMIC) in ablkcipher_next_slow
crypto/ablkcipher.c, 199: kmalloc(GFP_ATOMIC) in ablkcipher_copy_iv
crypto/ablkcipher.c, 315: kmalloc(GFP_ATOMIC) in setkey_unaligned

I meant to manually check the code, but I find that there are many 
functions calling ablkcipher_next_slow(),
ablkcipher_copy_iv() and setkey_unaligned(), so I am not sure whether 
the above three reports are true.

Could someone help me to validate these reports?
Thanks a lot in advance :)


Best wishes,
Jia-Ju Bai
