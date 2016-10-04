From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] crypto: sha1-powerpc: little-endian support
Date: Tue, 04 Oct 2016 17:23:16 +1100
Message-ID: <87pong4oq3.fsf@concordia.ellerman.id.au>
References: <1474659116-4689-1-git-send-email-marcelo.cerri@canonical.com> <20160928131551.GA31082@gallifrey> <20160928132015.GA21312@gondor.apana.org.au> <20160928132718.GB31082@gallifrey>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        George Wilson <gcwilson@us.ibm.com>,
        Claudio Carvalho <cclaudio@br.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@br.ibm.com>,
        joy.latten@canonical.com, "David S. Miller" <davem@davemloft.net>
To: Marcelo Cerri <marcelo.cerri@canonical.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160928132718.GB31082@gallifrey>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Marcelo Cerri <marcelo.cerri@canonical.com> writes:

> [ Unknown signature status ]
> On Wed, Sep 28, 2016 at 09:20:15PM +0800, Herbert Xu wrote:
>> On Wed, Sep 28, 2016 at 10:15:51AM -0300, Marcelo Cerri wrote:
>> > Hi Herbert,
>> > 
>> > Any thoughts on this one?
>> 
>> Can this patch wait until the next merge window? On the broken
>> platforms it should just fail the self-test, right?
>
> Yes. It fails on any LE platform (including Ubuntu and RHEL 7.1).

How are you testing this? I thought I was running the crypto tests but
I've never seen this fail.

cheers
