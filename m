From: Jitendra Lulla <lulla.jitendra@gmail.com>
Subject: RE: RFC: Crypto API User-interface
Date: Fri, 30 May 2014 16:52:53 +0530
Message-ID: <CAEux+EMZ2t4iBcZLMnuE4BAY-hoLc3Y23W8XmQmQP2H9gvKR-g@mail.gmail.com>
Reply-To: lullajd@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:50291 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaE3LXN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 May 2014 07:23:13 -0400
Received: by mail-ig0-f172.google.com with SMTP id uy17so658081igb.5
        for <linux-crypto@vger.kernel.org>; Fri, 30 May 2014 04:23:13 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

http://lwn.net/Articles/410848/
The following code is taken from the above page:

int main(void)
{
int opfd;
int tfmfd;
struct sockaddr_alg sa = {
.salg_family = AF_ALG,
.salg_type = "skcipher",
.salg_name = "cbc(aes)"
};
struct msghdr msg = {};
struct cmsghdr *cmsg;
char cbuf[CMSG_SPACE(4) + CMSG_SPACE(20)];
char buf[16];
struct af_alg_iv *iv;
struct iovec iov;
int i;
tfmfd = socket(AF_ALG, SOCK_SEQPACKET, 0);

bind(tfmfd, (struct sockaddr *)&sa, sizeof(sa));

setsockopt(tfmfd, SOL_ALG, ALG_SET_KEY,
  "\x06\xa9\x21\x40\x36\xb8\xa1\x5b"
  "\x51\x2e\x03\xd5\x34\x12\x00\x06", 16);

opfd = accept(tfmfd, NULL, 0);

msg.msg_control = cbuf;
msg.msg_controllen = sizeof(cbuf);

cmsg = CMSG_FIRSTHDR(&msg);
cmsg->cmsg_level = SOL_ALG;
cmsg->cmsg_type = ALG_SET_OP;
cmsg->cmsg_len = CMSG_LEN(4);
*(__u32 *)CMSG_DATA(cmsg) = ALG_OP_ENCRYPT;

cmsg = CMSG_NXTHDR(&msg, cmsg);
cmsg->cmsg_level = SOL_ALG;
cmsg->cmsg_type = ALG_SET_IV;
cmsg->cmsg_len = CMSG_LEN(20);
iv = (void *)CMSG_DATA(cmsg);
iv->ivlen = 16;
memcpy(iv->iv, "\x3d\xaf\xba\x42\x9d\x9e\xb4\x30"
      "\xb4\x22\xda\x80\x2c\x9f\xac\x41", 16);

iov.iov_base = "Single block msg";
iov.iov_len = 16;

msg.msg_iov = &iov;
msg.msg_iovlen = 1;

sendmsg(opfd, &msg, 0);
read(opfd, buf, 16);

for (i = 0; i < 16; i++) {
printf("%02x", (unsigned char)buf[i]);
}
printf("\n");
close(opfd);
close(tfmfd);

return 0;
}


Here the following small change is needed for this program to work:
memset(cbuf, 0, CMSG_SPACE(4) + CMSG_SPACE(20));
This memset is required otherwise the CMSG_NXTHDR  may return a NULL
causing a seg fault in the following line:
cmsg->cmsg_level = SOL_ALG;

I have tried this on 3.3.4-5.fc17.x86_64.

Posting this as it may help people who want to use/refer this example code.

However, can somebody please point me to some more examples which use
af_alg socket (without Openssl! as the af_alg engine for openssl
(http://src.carnivore.it/users/common/af_alg/) is incomplete
supporting only aes-cbc,sha1,sha2 only as of today. No other aes
variants supported in af_alg engine.)

I am particulart wanting to know how I can compute hmac and aes-xts or
ctr modes with af_alg without having to go via openssl.

~Jitendra
