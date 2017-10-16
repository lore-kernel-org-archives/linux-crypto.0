From: Christophe LEROY <christophe.leroy@c-s.fr>
Subject: md5sum (from libkcapi) fails on kernel 4.9 but not on 4.13
Date: Mon, 16 Oct 2017 08:53:00 +0200
Message-ID: <5c552c4b-c05e-7098-6e60-fdc6f7ed5d4b@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:15512 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750819AbdJPGxe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Oct 2017 02:53:34 -0400
Content-Language: fr
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

I get an issue with md5sum of a big file with kernel 4.9. It don't get 
that issue with kernel 4.13.

When I do an strace, I see a difference in the calls: at the end of the 
file, with 4.9 md5sum uses sendmsg() for the last block while with 4.13 
it uses splice() as for all the previous blocks.

The problem is that the last block has a size over 32kbytes, which is 
the maximum size the talitos driver accepts to hash at once.
It looks like sendmsg() sends the entire block to the crypto driver 
while splice() calls the crypto driver with blocks of page size.

Is there a way to workaround this issue on 4.9 ? Is there a way to avoid 
talitos ahash being called with more than 32kbytes of data ?

strace with 4.9 kernel:

...
vmsplice(5, 
[{"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 
558080}], 1, SPLICE_F_MORE|SPLICE_F_GIFT) = 262144
splice(4, NULL, 7, NULL, 262144, SPLICE_F_MORE) = 262144
vmsplice(5, 
[{"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 
295936}], 1, SPLICE_F_MORE|SPLICE_F_GIFT) = 262144
splice(4, NULL, 7, NULL, 262144, SPLICE_F_MORE) = 262144
sendmsg(7, {msg_name(0)=NULL, 
msg_iov(1)=[{"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 
33792}], msg_controllen=0, msg_flags=0}, MSG_MORE) = -1 EINVAL (Invalid 
argument)
write(2, "Generation of hash for file test"..., 45) = 45
...


strace with 4.13 kernel:

...
vmsplice(5, 
[{"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 
558080}], 1, SPLICE_F_MORE|SPLICE_F_GIFT) = 262144
splice(4, NULL, 7, NULL, 262144, SPLICE_F_MORE) = 262144
vmsplice(5, 
[{"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 
295936}], 1, SPLICE_F_MORE|SPLICE_F_GIFT) = 262144
splice(4, NULL, 7, NULL, 262144, SPLICE_F_MORE) = 262144
vmsplice(5, 
[{"\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 
33792}], 1, SPLICE_F_MORE|SPLICE_F_GIFT) = 33792
splice(4, NULL, 7, NULL, 33792, SPLICE_F_MORE) = 33792
recvmsg(7, {msg_name(0)=NULL, 
msg_iov(1)=[{"\"\35|\3273\302\35\252\4\276l\210\315B\210^", 64}], 
msg_controllen=0, msg_flags=0}, 0) = 16
fstat64(1, {st_mode=S_IFCHR|0600, st_rdev=makedev(204, 46), ...}) = 0
ioctl(1, TCGETS, {B115200 opost isig icanon echo ...}) = 0
write(1, "221d7cd733c21daa04be6c88cd42885e"..., 39) = 39
...

Thanks
Christophe
