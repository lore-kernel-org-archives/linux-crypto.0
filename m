Return-Path: <SRS0=oFif=NX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:51403 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbeKMJtd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Nov 2018 04:49:33 -0500
MIME-Version: 1.0
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-24-Jason@zx2c4.com>
 <7830522a-968e-0880-beb7-44904466cf14@labo.rs> <CAHmME9oQJ9y51Pv7U=+=5uDA_tb+U1zWZdsLcyNMhdcFZmjM8Q@mail.gmail.com>
 <e4b500e9-f24a-43c5-c2df-834dafc3aae5@labo.rs>
In-Reply-To: <e4b500e9-f24a-43c5-c2df-834dafc3aae5@labo.rs>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 12 Nov 2018 18:53:55 -0500
Message-ID: <CAHmME9q8tp3Ch43o3D6zYTVujcjBWLVpNdzVw6RqYqHisd_suQ@mail.gmail.com>
Subject: Re: [PATCH net-next v6 23/23] net: WireGuard secure network tunnel
To: labokml@labo.rs
Cc: Dave Taht <dave.taht@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hey Ivan,

Sorry for not getting back to you sooner.

On Mon, Nov 5, 2018 at 8:06 AM Ivan Lab=C3=A1th <labokml@labo.rs> wrote:
> Any news on this?
>
> To be clear, question is not about an insignificant documentation
> oversight. It is about copying bits from inner packets to outer packets

The short answer is RFC6040 with DSCP fixed to 0 so as not to leak
anything. I've added a description of this to
<wireguard.com/protocol/>.

Regards,
Jason
