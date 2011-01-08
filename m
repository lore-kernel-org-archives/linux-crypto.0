From: Hamid Nassiby <h.nassiby@gmail.com>
Subject: Re: Fwd: crypto accelerator driver problems
Date: Sat, 8 Jan 2011 11:09:18 +0330
Message-ID: <AANLkTinm8uy34ni_4XFLZTcdkndy0B_jeFXag0onxA66@mail.gmail.com>
References: <AANLkTinGGsjgBKD1LqhL2u4DOU_XrACK4D67nHfPnL5e@mail.gmail.com> <20101230211900.GA22742@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58542 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab1AHHju convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 8 Jan 2011 02:39:50 -0500
Received: by gyb11 with SMTP id 11so6831878gyb.19
        for <linux-crypto@vger.kernel.org>; Fri, 07 Jan 2011 23:39:50 -0800 (PST)
In-Reply-To: <20101230211900.GA22742@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 31, 2010 at 12:49 AM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
>
> Hamid Nassiby <h.nassiby@gmail.com> wrote:
> > Hi,
> >
> > As some good news and additional information, with the following pa=
tch
> > I no more get
> > "UDP bad cheksum" error as I mentioned erlier with Iperf in udp mod=
e.
> > But some times I get the following call trace in dmesg after runnin=
g
> > Iperf in UDP mode, more than one time (and ofcourse Iperf stops
> > transferring data while it uses 100% of CPU cycles.
> >
> >
> >
> > [ =C2=A0130.171909] mydriver-aes: mydriver Crypto-Engine enabled.
> > [ =C2=A0134.767846] NET: Registered protocol family 15
> > [ =C2=A0200.031846] iperf: page allocation failure. order:0, mode:0=
x20
> > [ =C2=A0200.031850] Pid: 10935, comm: iperf Tainted: P =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A02.6.36-zen1 #1
> > [ =C2=A0200.031852] Call Trace:
> > [ =C2=A0200.031860] =C2=A0[<ffffffff8108ab39>] ? __alloc_pages_node=
mask+0x6d3/0x722
> > [ =C2=A0200.031864] =C2=A0[<ffffffff810b454f>] ? virt_to_head_page+=
0x9/0x30
> > [ =C2=A0200.031867] =C2=A0[<ffffffff810afac2>] ? alloc_pages_curren=
t+0xa5/0xce
> > [ =C2=A0200.031869] =C2=A0[<ffffffff810899ad>] ? __get_free_pages+0=
x9/0x46
> > [ =C2=A0200.031872] =C2=A0[<ffffffff8102bbbf>] ? need_resched+0x1a/=
0x23
> > [ =C2=A0200.031876] =C2=A0[<ffffffff811a10ad>] ? blkcipher_walk_nex=
t+0x68/0x2d9
>
> This means that your box has run out of memory temporarily.
> If all errors were handled correctly it should continue at this
> point.
>
> > --- mydriver1 =C2=A0 2010-12-21 15:20:17.000000000 +0330
> > +++ mydriver2 =C2=A0 2010-12-21 15:24:18.000000000 +0330
> > @@ -1,4 +1,3 @@
> > -
> > static int
> > mydriver_cbc_decrypt(struct blkcipher_desc *desc,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struc=
t scatterlist *dst, struct scatterlist *src,
> > @@ -14,18 +13,17 @@ mydriver_cbc_decrypt(struct blkcipher_desc
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D blkcipher_walk_virt(desc, &walk)=
;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0op->iv =3D walk.iv;
> >
> > - =C2=A0 =C2=A0 =C2=A0 while((nbytes =3D walk.nbytes)) {
> > +
>
> However, your patch removes the error checking (and the loop
> condition) which is why it crashes.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt



Hi Herbert,

=46irst I should notice that by removing while loop iteration, "UDP bad=
 checksum"
error in dmesg output is no longer seen. Diving deeper in problem, It s=
eemed
to me that when mydriver_transform returns 0, I must not get any more b=
ytes
(belonging to previous request) to process in the next iteration of whi=
le loop.
But I see that the behavior is not as it has to be (By removing while l=
oop
mydriver_transform gets for example one 1500 byte request, processes it=
 and
copies it back to destination, But in existence of while loop It gets s=
ame
request as one 1300 byte request, processes and copies it back to desti=
nation,
returning 0, and getting remaining 200 bytes of request in second itera=
tion of
while, so on the other end of tunnel I see "UDP bad checksum"). So I co=
nclude
that blkcipher_walk_done behaves strange, assigns incorrect value to wa=
lk.nbytes
resulting in iterating while loop one time more!


Second note is about our accelerator's architecture and the way we shou=
ld
utilize it. Our device has several crypto engines built in. So for maxi=
mum
utilization of device we should feed it with multiple crypto requests
simultaneously (I intended for doing  it by using pcrypt) and here is t=
he point
everything freezes. From other point of view, I found that if I protect=
 entering
write_request and read_response in mydriver_transform by one lock
(spin_unlock(x) before write_request and spin_unlock(x) after read_reas=
ponse in
mydriver_transform as shown in following code snippet), I would be able=
 to run
"iperf" in tcp mode successfully. This leads me to uncertainty, because=
 in
such a situation, we only utilize one crypto engine of device and each =
request
is followed by its response sequentially and arrangement of requests an=
d
responses is not interleaved. So I guess that getting multiple requests=
 to
device and receiving the responses not in the same arrangement they del=
ivered to
device, might cause TCP transfer to freeze, and here my question arises=
: If my
conclusion is true, SHOULD I change the driver approach to ablkcipher?


Code snippet in the way write_request and read_response are protected b=
y lock
and iperf in TCP mode progresses:


static inline int mydriver_transform(struct mydriver_aes_op *op, int al=
g)
{
		.
		.
		.
		spin_lock_irqsave(&glock, tflag);
		write_request(req_buf, req_len);
		kfree(req_buf);
		req_buf =3D NULL;
		err =3D read_response(&res_buf,my_req_id);
		spin_unlock_irqrestore(&glock, tflag2);
		if (err =3D=3D 0){
				kfree(res_buf);
				res_buf =3D NULL;
				return 0;
		}

		memcpy(op->dst, (res_buf + sizeof(struct response_hdr)),
op->len);
	=09
		kfree(res_buf);
		res_buf =3D NULL;
		return op->len;
}


I'm looking forward to hearing you soon.
Thanks,

Hamid.
