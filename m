From: Sonny Rao <sonnyrao@chromium.org>
Subject: Using s5p-sss hw crypto causes ipsec to break
Date: Mon, 23 Jun 2014 17:36:20 -0700
Message-ID: <CAPz6YkUtGt61YNcGh2sYhaL=U5JMSOu26DvuKXuvp-oxi9ftBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Douglas Anderson <dianders@chromium.org>, ch.naveen@samsung.com,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	vzapolskiy@gmail.com
To: linux-crypto@vger.kernel.org
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi, I've been investigating an issue relating to hardware crypto which
is that when I enable the s5p-sss module for hardware cryptographic
acceleration on Samsung Exynos SoCs the in-kernel IPSec seems to
break, although cryptographic operations on filesystems/block devices
using this driver seem to work fine.

Originally we were looking at an older kernel (3.8 with patches), but
I've now verified on linux-next from 20140612 (after 3.15) with a few
additional patches (to enable both s5p-sss and Exynos5420) that this
is still the case.

It looks like what is happening in the kernel is that IPsec ends up
with this callstack

esp_output()-> crypto_aead_givencrypt()->
crypto_authenc_givencrypt()-> eseqiv_givencrypt() ->
crypto_ablkcipher_encrypt()


which calls into the s5p-sss driver and that is returning -EINPROGRESS
(or possibly -EBUSY), and that is passed all the way back up the call
stack and that seems to be treated as an error condition by the ipsec
stack.

For example esp_output does this:

       err = crypto_aead_givencrypt(req);
        if (err == -EINPROGRESS)
                goto error;

        if (err == -EBUSY)
                err = NET_XMIT_DROP;

So, I'm not sure how this is supposed to work, or if s5p-sss is doing
something wrong.

In the case of the block layer, it seems to be tolerant of the
-EINPROGRESS return code.  I looked at some of the other hw crypto
drivers which are similar to s5p-sss and they also seem to return
-EINPROGRESS or -EBUSY in a similar way.

I was also wondering if esp shouldn't be using the ablkcipher
interface if it isn't tolerant of the -EINPROGRESS?
