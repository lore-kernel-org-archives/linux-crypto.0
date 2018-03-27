From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH 07/10] kbuild: clean up *-asn1.[ch] patterns from
 top-level Makefile
Date: Tue, 27 Mar 2018 15:04:51 +0900
Message-ID: <CAK7LNATQfgMZJYRA7=8wpYRXCKO3xj2xxXgSAur6mf8ajFmQdQ@mail.gmail.com>
References: <1521810279-6282-1-git-send-email-yamada.masahiro@socionext.com> <1521810279-6282-7-git-send-email-yamada.masahiro@socionext.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Sam Ravnborg <sam@ravnborg.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Frank Rowand <frank.rowand@sony.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        linux-crypto@vger.kernel.org
To: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521810279-6282-7-git-send-email-yamada.masahiro@socionext.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

+CC linux-crypto@vger.kernel.org

No functional change, though.

2018-03-23 22:04 GMT+09:00 Masahiro Yamada <yamada.masahiro@socionext.com>:
> Clean up these patterns from the top Makefile to omit 'clean-files'
> in each Makefile.
>
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> ---
>
>  Makefile                        | 1 +
>  crypto/Makefile                 | 2 --
>  crypto/asymmetric_keys/Makefile | 7 -------
>  net/ipv4/netfilter/Makefile     | 1 -
>  4 files changed, 1 insertion(+), 10 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index 168432e..054f43a 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1614,6 +1614,7 @@ clean: $(clean-dirs)
>                 -o -name '*.su'  \
>                 -o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
>                 -o -name '*.lex.c' -o -name '*.tab.[ch]' \
> +               -o -name '*-asn1.[ch]' \
>                 -o -name '*.symtypes' -o -name 'modules.order' \
>                 -o -name modules.builtin -o -name '.tmp_*.o.*' \
>                 -o -name .cache.mk \
> diff --git a/crypto/Makefile b/crypto/Makefile
> index cdbc03b..4eae4da 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -38,8 +38,6 @@ obj-$(CONFIG_CRYPTO_DH) += dh_generic.o
>  $(obj)/rsapubkey-asn1.o: $(obj)/rsapubkey-asn1.c $(obj)/rsapubkey-asn1.h
>  $(obj)/rsaprivkey-asn1.o: $(obj)/rsaprivkey-asn1.c $(obj)/rsaprivkey-asn1.h
>  $(obj)/rsa_helper.o: $(obj)/rsapubkey-asn1.h $(obj)/rsaprivkey-asn1.h
> -clean-files += rsapubkey-asn1.c rsapubkey-asn1.h
> -clean-files += rsaprivkey-asn1.c rsaprivkey-asn1.h
>
>  rsa_generic-y := rsapubkey-asn1.o
>  rsa_generic-y += rsaprivkey-asn1.o
> diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
> index 4719aad..bd8ed09 100644
> --- a/crypto/asymmetric_keys/Makefile
> +++ b/crypto/asymmetric_keys/Makefile
> @@ -29,9 +29,6 @@ $(obj)/x509_cert_parser.o: \
>  $(obj)/x509-asn1.o: $(obj)/x509-asn1.c $(obj)/x509-asn1.h
>  $(obj)/x509_akid-asn1.o: $(obj)/x509_akid-asn1.c $(obj)/x509_akid-asn1.h
>
> -clean-files    += x509-asn1.c x509-asn1.h
> -clean-files    += x509_akid-asn1.c x509_akid-asn1.h
> -
>  #
>  # PKCS#7 message handling
>  #
> @@ -45,8 +42,6 @@ pkcs7_message-y := \
>  $(obj)/pkcs7_parser.o: $(obj)/pkcs7-asn1.h
>  $(obj)/pkcs7-asn1.o: $(obj)/pkcs7-asn1.c $(obj)/pkcs7-asn1.h
>
> -clean-files    += pkcs7-asn1.c pkcs7-asn1.h
> -
>  #
>  # PKCS#7 parser testing key
>  #
> @@ -66,5 +61,3 @@ verify_signed_pefile-y := \
>
>  $(obj)/mscode_parser.o: $(obj)/mscode-asn1.h $(obj)/mscode-asn1.h
>  $(obj)/mscode-asn1.o: $(obj)/mscode-asn1.c $(obj)/mscode-asn1.h
> -
> -clean-files    += mscode-asn1.c mscode-asn1.h
> diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
> index 2dad20e..e5f5638 100644
> --- a/net/ipv4/netfilter/Makefile
> +++ b/net/ipv4/netfilter/Makefile
> @@ -31,7 +31,6 @@ obj-$(CONFIG_NF_NAT_PPTP) += nf_nat_pptp.o
>  nf_nat_snmp_basic-y := nf_nat_snmp_basic-asn1.o nf_nat_snmp_basic_main.o
>  nf_nat_snmp_basic-y : nf_nat_snmp_basic-asn1.h nf_nat_snmp_basic-asn1.c
>  obj-$(CONFIG_NF_NAT_SNMP_BASIC) += nf_nat_snmp_basic.o
> -clean-files := nf_nat_snmp_basic-asn1.c nf_nat_snmp_basic-asn1.h
>
>  obj-$(CONFIG_NF_NAT_MASQUERADE_IPV4) += nf_nat_masquerade_ipv4.o
>
> --
> 2.7.4
>



-- 
Best Regards
Masahiro Yamada
