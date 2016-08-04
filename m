From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] crypto: crc32c-vpmsum - Convert to CPU feature based
 module autoloading
Date: Thu, 4 Aug 2016 20:26:01 +1000
Message-ID: <20160804202601.12aa879e@kryten>
References: <1470292695-9829-1-git-send-email-anton@ozlabs.org>
 <87lh0dexp3.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, paulus@samba.org, linux-crypto@vger.kernel.org,
 alastair@d-silva.org, linuxppc-dev@lists.ozlabs.org, davem@davemloft.net
To: Michael Ellerman <mpe@ellerman.id.au>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <87lh0dexp3.fsf@concordia.ellerman.id.au>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

Hi Michael,

> Is VEC_CRYPTO the right feature?
> 
> That's new power8 crypto stuff.

The vpmsum* instructions are part of the same pipeline as the vcipher*
instructions, introduced in POWER8.

> I thought this only used VMX? (but I haven't looked closely)

Yes, vcipher* and vpmsum* are VMX instructions.

Anton
