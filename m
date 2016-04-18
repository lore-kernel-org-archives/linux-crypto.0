From: "Thomas D." <whissi@whissi.de>
Subject: Re: [PATCH] Re: Broken userspace crypto in linux-4.1.18
Date: Mon, 18 Apr 2016 11:48:42 +0200
Message-ID: <8cf2e39f-003a-3af8-2666-bbaf43035995@whissi.de>
References: <56C5A66E.5010905@whissi.de> <56C87929.8040304@whissi.de>
 <56C9E865.3050500@gmail.com> <56CD6AB6.7000801@suse.cz>
 <56CD6FD8.20004@gmail.com> <20160224171203.GE16597@kroah.com>
 <56D0361B.8040301@gmail.com> <56D080AA.7030307@oracle.com>
 <7210213c-7446-5181-c2b2-8d7aaa756a2a@whissi.de>
 <57141096.1000802@oracle.com> <20160418020230.GA16179@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Milan Broz <gmazyland@gmail.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Jiri Slaby <jslaby@suse.cz>,
	Stephan Mueller <smueller@chronox.de>,
	Willy Tarreau <w@1wt.eu>,
	"dvyukov@google.com" <dvyukov@google.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Ondrej Kozina <okozina@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sasha.levin@oracle.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160418020230.GA16179@gondor.apana.org.au>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

Milan's patches apply against 3.18.30, however I am getting build error=
s:

> *  CC [M]  fs/fat/namei_vfat.o
> *  CC [M]  crypto/algif_hash.o
> *  LD [M]  fs/isofs/isofs.o
> *  CC [M]  crypto/algif_skcipher.o
> *  LD [M]  fs/fat/fat.o
> *crypto/algif_hash.c:350:13: warning: initialization from incompatibl=
e pointer type [-Wincompatible-pointer-types]
> *  .sendmsg =3D hash_sendmsg_nokey,
> *             ^
> *crypto/algif_hash.c:350:13: note: (near initialization for =91algif_=
hash_ops_nokey.sendmsg=92)
> *crypto/algif_hash.c:352:13: warning: initialization from incompatibl=
e pointer type [-Wincompatible-pointer-types]
> *--
> *crypto/algif_hash.c:352:13: note: (near initialization for =91algif_=
hash_ops_nokey.recvmsg=92)
> *  CC [M]  drivers/acpi/fan.o
> *  CC [M]  crypto/xor.o
> *  LD [M]  fs/fat/msdos.o
> *crypto/algif_skcipher.c: In function =91skcipher_sendmsg_nokey=92:
> *crypto/algif_skcipher.c:599:26: warning: passing argument 1 of =91sk=
cipher_sendmsg=92 from incompatible pointer type [-Wincompatible-pointe=
r-types]
> *  return skcipher_sendmsg(sock, msg, size);
> *                          ^
> *crypto/algif_skcipher.c:247:12: note: expected =91struct kiocb *=92 =
but argument is of type =91struct socket *=92
> * static int skcipher_sendmsg(struct kiocb *unused, struct socket *so=
ck,
> *            ^
> *crypto/algif_skcipher.c:599:32: warning: passing argument 2 of =91sk=
cipher_sendmsg=92 from incompatible pointer type [-Wincompatible-pointe=
r-types]
> *  return skcipher_sendmsg(sock, msg, size);
> *                                ^
> *crypto/algif_skcipher.c:247:12: note: expected =91struct socket *=92=
 but argument is of type =91struct msghdr *=92
> * static int skcipher_sendmsg(struct kiocb *unused, struct socket *so=
ck,
> *            ^
> *crypto/algif_skcipher.c:599:37: warning: passing argument 3 of =91sk=
cipher_sendmsg=92 makes pointer from integer without a cast [-Wint-conv=
ersion]
> *  return skcipher_sendmsg(sock, msg, size);
> *                                     ^
> *crypto/algif_skcipher.c:247:12: note: expected =91struct msghdr *=92=
 but argument is of type =91size_t {aka long unsigned int}=92
> * static int skcipher_sendmsg(struct kiocb *unused, struct socket *so=
ck,
> *            ^
> *crypto/algif_skcipher.c:599:9: error: too few arguments to function =
=91skcipher_sendmsg=92
> *--
> *         ^
> *crypto/algif_skcipher.c:247:12: note: declared here
> * static int skcipher_sendmsg(struct kiocb *unused, struct socket *so=
ck,
> *            ^
> *crypto/algif_skcipher.c: In function =91skcipher_recvmsg_nokey=92:
> *crypto/algif_skcipher.c:623:26: warning: passing argument 1 of =91sk=
cipher_recvmsg=92 from incompatible pointer type [-Wincompatible-pointe=
r-types]
> *  return skcipher_recvmsg(sock, msg, ignored, flags);
> *                          ^
> *crypto/algif_skcipher.c:426:12: note: expected =91struct kiocb *=92 =
but argument is of type =91struct socket *=92
> * static int skcipher_recvmsg(struct kiocb *unused, struct socket *so=
ck,
> *            ^
> *crypto/algif_skcipher.c:623:32: warning: passing argument 2 of =91sk=
cipher_recvmsg=92 from incompatible pointer type [-Wincompatible-pointe=
r-types]
> *  return skcipher_recvmsg(sock, msg, ignored, flags);
> *                                ^
> *crypto/algif_skcipher.c:426:12: note: expected =91struct socket *=92=
 but argument is of type =91struct msghdr *=92
> * static int skcipher_recvmsg(struct kiocb *unused, struct socket *so=
ck,
> *            ^
> *crypto/algif_skcipher.c:623:37: warning: passing argument 3 of =91sk=
cipher_recvmsg=92 makes pointer from integer without a cast [-Wint-conv=
ersion]
> *  return skcipher_recvmsg(sock, msg, ignored, flags);
> *                                     ^
> *crypto/algif_skcipher.c:426:12: note: expected =91struct msghdr *=92=
 but argument is of type =91size_t {aka long unsigned int}=92
> * static int skcipher_recvmsg(struct kiocb *unused, struct socket *so=
ck,
> *            ^
> *crypto/algif_skcipher.c:623:9: error: too few arguments to function =
=91skcipher_recvmsg=92
> *--
> *         ^
> *crypto/algif_skcipher.c:426:12: note: declared here
> * static int skcipher_recvmsg(struct kiocb *unused, struct socket *so=
ck,
> *            ^
> *crypto/algif_skcipher.c: At top level:
> *crypto/algif_skcipher.c:642:13: warning: initialization from incompa=
tible pointer type [-Wincompatible-pointer-types]
> *  .sendmsg =3D skcipher_sendmsg_nokey,
> *             ^
> *crypto/algif_skcipher.c:642:13: note: (near initialization for =91al=
gif_skcipher_ops_nokey.sendmsg=92)
> *crypto/algif_skcipher.c:644:13: warning: initialization from incompa=
tible pointer type [-Wincompatible-pointer-types]
> *  .recvmsg =3D skcipher_recvmsg_nokey,
> *             ^
> *crypto/algif_skcipher.c:644:13: note: (near initialization for =91al=
gif_skcipher_ops_nokey.recvmsg=92)
> *crypto/algif_skcipher.c: In function =91skcipher_recvmsg_nokey=92:
> *crypto/algif_skcipher.c:624:1: warning: control reaches end of non-v=
oid function [-Wreturn-type]
> * }
> * ^
> *crypto/algif_skcipher.c: In function =91skcipher_sendmsg_nokey=92:
> *  CC [M]  crypto/async_tx/async_tx.o
> *crypto/algif_skcipher.c:600:1: warning: control reaches end of non-v=
oid function [-Wreturn-type]
> * }
> * ^
> *  LD [M]  fs/fat/vfat.o
> *scripts/Makefile.build:263: recipe for target 'crypto/algif_skcipher=
=2Eo' failed
> *make[1]: *** [crypto/algif_skcipher.o] Error 1
> *--
> *  CC [M]  arch/x86/oprofile/../../../drivers/oprofile/buffer_sync.o
> *  CC [M]  drivers/i2c/busses/i2c-piix4.o
> *  CC [M]  arch/x86/oprofile/../../../drivers/oprofile/event_buffer.o
> *  CC [M]  arch/x86/oprofile/../../../drivers/oprofile/oprofile_files=
=2Eo
> *  CC [M]  arch/x86/oprofile/../../../drivers/oprofile/oprofile_stats=
=2Eo
> *Makefile:937: recipe for target 'crypto' failed
> *make: *** [crypto] Error 2


-Thomas
