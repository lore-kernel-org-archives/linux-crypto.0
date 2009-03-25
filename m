From: Lee Nipper <lee.nipper@gmail.com>
Subject: Re: Talitos on MPC8548
Date: Tue, 24 Mar 2009 22:50:58 -0500
Message-ID: <eabe9a7b0903242050r390f8006wa7e8d6968ba9dd51@mail.gmail.com>
References: <200903191736.n2JHaCu20819@sierra.gdatech.com>
	 <49C379E0.2090709@gmail.com>
	 <200903240108.n2O185u14889@sierra.gdatech.com>
Reply-To: lee.nipper@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: "G.Muruganandam" <gmuruga@gdatech.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:46642 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730AbZCYDvB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Mar 2009 23:51:01 -0400
Received: by fk-out-0910.google.com with SMTP id 18so1135839fkq.5
        for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2009 20:50:58 -0700 (PDT)
In-Reply-To: <200903240108.n2O185u14889@sierra.gdatech.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 23, 2009 at 20:05, G.Muruganandam <gmuruga@gdatech.com> wro=
te:
>
> After going through the docs and some googling,
> I am planning to use the following topologies using
> MPC8548 boards ( I have two boards )
> To start with, I'll use the topology I . Pl let me know
> your comments.
>
>
> Topology -I:
> =3D=3D=3D=3D=3D=3D=3D=3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A010.15.109.101 10.15.109.100
> Host A--------------------------MPC8548 -----------------------------=
Host B
> 192.168.50.5 =A0 =A0 =A0 =A0 192.168.50.1
>
>
> Topology-II:
> =3D=3D=3D=3D=3D=3D=3D=3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 10.15.109.101 =A0 =A0 10.15.109.100
> Host----------------------MPC8548-1--------------------MPC8548-2-----=
------Host
> 192.168.50.5 =A0 =A0 192.168.50.1 192.168.1.1 =A0 =A0 =A0 =A0192.168.=
1.10
>
>

You need to decide whether you are using "transport mode"
or "tunnel mode", and which hosts be doing IPsec.
Topoplogy-II will work fine for the 8548 boards operating in "tunnel mo=
de".

=46or Topology-I,  I don't know what you have in mind.  It takes at
least 4 systems for "tunnel mode"...
2 endpoints and 2 hosts in the middle for the IPsec tunnel.
You can do "transport mode" with 2 or more systems
since it is endpoint to endpoint.  But in that case Topology-I doesn't
have the 8548 doing any IPsec work since it's not an endpoint.

Best Regards,
Lee
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
