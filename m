From: Hamid Nassiby <h.nassiby@gmail.com>
Subject: Re: Fwd: crypto accelerator driver problems
Date: Wed, 26 Jan 2011 10:46:34 +0330
Message-ID: <AANLkTim+-gZvS=yPXyRW0oWDWWjYt3LYeeSQ7GmhkD74@mail.gmail.com>
References: <AANLkTinGGsjgBKD1LqhL2u4DOU_XrACK4D67nHfPnL5e@mail.gmail.com>
 <20101230211900.GA22742@gondor.apana.org.au> <AANLkTinm8uy34ni_4XFLZTcdkndy0B_jeFXag0onxA66@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58970 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab1AZHRG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 26 Jan 2011 02:17:06 -0500
Received: by gwj20 with SMTP id 20so24684gwj.19
        for <linux-crypto@vger.kernel.org>; Tue, 25 Jan 2011 23:17:05 -0800 (PST)
In-Reply-To: <AANLkTinm8uy34ni_4XFLZTcdkndy0B_jeFXag0onxA66@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jan 8, 2011 at 11:09 AM, Hamid Nassiby <h.nassiby@gmail.com> wr=
ote:
>
> On Fri, Dec 31, 2010 at 12:49 AM, Herbert Xu
> <herbert@gondor.apana.org.au> wrote:
> >
> > Hamid Nassiby <h.nassiby@gmail.com> wrote:
> > > Hi,
> > >
> > > As some good news and additional information, with the following =
patch
> > > I no more get
> > > "UDP bad cheksum" error as I mentioned erlier with Iperf in udp m=
ode.
> > > But some times I get the following call trace in dmesg after runn=
ing
> > > Iperf in UDP mode, more than one time (and ofcourse Iperf stops
> > > transferring data while it uses 100% of CPU cycles.
> > >
> > >
> > >
> > > [ =C2=A0130.171909] mydriver-aes: mydriver Crypto-Engine enabled.
> > > [ =C2=A0134.767846] NET: Registered protocol family 15
> > > [ =C2=A0200.031846] iperf: page allocation failure. order:0, mode=
:0x20
> > > [ =C2=A0200.031850] Pid: 10935, comm: iperf Tainted: P =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A02.6.36-zen1 #1
> > > [ =C2=A0200.031852] Call Trace:
> > > [ =C2=A0200.031860] =C2=A0[<ffffffff8108ab39>] ? __alloc_pages_no=
demask+0x6d3/0x722
> > > [ =C2=A0200.031864] =C2=A0[<ffffffff810b454f>] ? virt_to_head_pag=
e+0x9/0x30
> > > [ =C2=A0200.031867] =C2=A0[<ffffffff810afac2>] ? alloc_pages_curr=
ent+0xa5/0xce
> > > [ =C2=A0200.031869] =C2=A0[<ffffffff810899ad>] ? __get_free_pages=
+0x9/0x46
> > > [ =C2=A0200.031872] =C2=A0[<ffffffff8102bbbf>] ? need_resched+0x1=
a/0x23
> > > [ =C2=A0200.031876] =C2=A0[<ffffffff811a10ad>] ? blkcipher_walk_n=
ext+0x68/0x2d9
> >
> > This means that your box has run out of memory temporarily.
> > If all errors were handled correctly it should continue at this
> > point.
> >
> > > --- mydriver1 =C2=A0 2010-12-21 15:20:17.000000000 +0330
> > > +++ mydriver2 =C2=A0 2010-12-21 15:24:18.000000000 +0330
> > > @@ -1,4 +1,3 @@
> > > -
> > > static int
> > > mydriver_cbc_decrypt(struct blkcipher_desc *desc,
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0str=
uct scatterlist *dst, struct scatterlist *src,
> > > @@ -14,18 +13,17 @@ mydriver_cbc_decrypt(struct blkcipher_desc
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D blkcipher_walk_virt(desc, &wal=
k);
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0op->iv =3D walk.iv;
> > >
> > > - =C2=A0 =C2=A0 =C2=A0 while((nbytes =3D walk.nbytes)) {
> > > +
> >
> > However, your patch removes the error checking (and the loop
> > condition) which is why it crashes.
> >
> > Cheers,
> > --
> > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > Home Page: http://gondor.apana.org.au/~herbert/
> > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
>
>
> Hi Herbert,
>
> First I should notice that by removing while loop iteration, "UDP bad=
 checksum"
> error in dmesg output is no longer seen. Diving deeper in problem, It=
 seemed
> to me that when mydriver_transform returns 0, I must not get any more=
 bytes
> (belonging to previous request) to process in the next iteration of w=
hile loop.
> But I see that the behavior is not as it has to be (By removing while=
 loop
> mydriver_transform gets for example one 1500 byte request, processes =
it and
> copies it back to destination, But in existence of while loop It gets=
 same
> request as one 1300 byte request, processes and copies it back to des=
tination,
> returning 0, and getting remaining 200 bytes of request in second ite=
ration of
> while, so on the other end of tunnel I see "UDP bad checksum"). So I =
conclude
> that blkcipher_walk_done behaves strange, assigns incorrect value to =
walk.nbytes
> resulting in iterating while loop one time more!
>
>
> Second note is about our accelerator's architecture and the way we sh=
ould
> utilize it. Our device has several crypto engines built in. So for ma=
ximum
> utilization of device we should feed it with multiple crypto requests
> simultaneously (I intended for doing =C2=A0it by using pcrypt) and he=
re is the point
> everything freezes. From other point of view, I found that if I prote=
ct entering
> write_request and read_response in mydriver_transform by one lock
> (spin_unlock(x) before write_request and spin_unlock(x) after read_re=
asponse in
> mydriver_transform as shown in following code snippet), I would be ab=
le to run
> "iperf" in tcp mode successfully. This leads me to uncertainty, becau=
se in
> such a situation, we only utilize one crypto engine of device and eac=
h request
> is followed by its response sequentially and arrangement of requests =
and
> responses is not interleaved. So I guess that getting multiple reques=
ts to
> device and receiving the responses not in the same arrangement they d=
elivered to
> device, might cause TCP transfer to freeze, and here my question aris=
es: If my
> conclusion is true, SHOULD I change the driver approach to ablkcipher=
?
>
>
> Code snippet in the way write_request and read_response are protected=
 by lock
> and iperf in TCP mode progresses:
>
>
> static inline int mydriver_transform(struct mydriver_aes_op *op, int =
alg)
> {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock_irqs=
ave(&glock, tflag);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0write_request(=
req_buf, req_len);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(req_buf)=
;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0req_buf =3D NU=
LL;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D read_r=
esponse(&res_buf,my_req_id);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock_ir=
qrestore(&glock, tflag2);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (err =3D=3D=
 0){
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(res_buf);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0res_buf =3D NULL;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0memcpy(op->dst=
, (res_buf + sizeof(struct response_hdr)),
> op->len);
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(res_buf)=
;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0res_buf =3D NU=
LL;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return op->len=
;
> }
>
>
> I'm looking forward to hearing you soon.
> Thanks,
>
> Hamid.



Hi,

As you know, I posted my problem again to crypto list and no one answer=
ed. Now I
emphasize one aspect of the problem as a concept related to IPSec proto=
col, free
of my problem's nature, and I hope to get some guidelines at this time.=
 The
question is as following:
If IPSec delivers IP packets to hardware crypto accelerator in sequenti=
al manner
(e.g, packets in order: 1, 2, 3, ..., 36, 37, 38,...) and crypto accele=
rator
possibly returns back packets out of entering order to IPSec (e.g, pack=
et
37 is returned back before the packet 36 to IPSec, so the order of pack=
ets is
not the same before entering crypto accelerator and after exiting it); =
Is it
possible to rise any problem here?

Thanks in advance,

Hamid.
