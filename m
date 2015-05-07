From: Yao Dongdong <yaodongdong@huawei.com>
Subject: [Question] AEAD crypto api for userspace can't deal with a PTlen=0
 vector
Date: Thu, 7 May 2015 17:44:53 +0800
Message-ID: <554B3415.3060707@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, "Lihui (Eric)" <lihui8@huawei.com>
To: <smueller@chronox.de>, <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:32670 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbbEGJpG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 May 2015 05:45:06 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

while we use crypto api for userspace to do vectors test for AEAD(aes-gcm),
we encounter a problem. There are some test vector's PTlen is 0,for example:
[Keylen = 128]
[IVlen = 96]
[PTlen = 0]
[AADlen = 0]
[Taglen = 128]

Count = 0
Key = 7e93936b2e2188cfa9c9882ad901312f
IV = b6879804163b9eaf5bfe5218
CT =
AAD =
Tag = aa77daf382d0d63480ff8c8a2dee149e

In testing vectors like that, we will get an error result that the decrypt
return is success but the right return is a ghash verify fail.
After digging into the kernel(3.10) code, we find the function sock_aio_read
in net/socket.c has a judgement of iocb->ki_left which will be 0 when we
do an aes-gcm decrypt decribed above.

static ssize_t sock_aio_read(struct kiocb *iocb, const struct iovec *iov,
                unsigned long nr_segs, loff_t pos)
{
    struct sock_iocb siocb, *x;

    if (pos != 0)
        return -ESPIPE;

    if (iocb->ki_left == 0) /* Match SYS5 behaviour */
        return 0;

    x = alloc_sock_iocb(iocb, &siocb);
    if (!x)
        return -ENOMEM;
    return do_sock_read(&x->async_msg, iocb, iocb->ki_filp, iov, nr_segs);
}

So it directly return before calling aes-gcm decrypt.

How can we deal with that?

-- 
Kind regards,
Yao Dongdong
